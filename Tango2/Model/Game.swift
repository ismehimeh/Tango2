//
//  Game.swift
//  Tango
//
//  Created by Sergei Vasilenko on 11.03.2025.
//

import Foundation

@Observable
class Game {

    let level: Level
    
    var lineLength: Int {
        level.lineLength
    }
    
    var gameCells: [GameCell]
    
    var gameConditions: [GameCellCondition] {
        level.gameConditions
    }
    var isSolved = true
    var isMistake = false
    var mistakes = [Mistake]()
    var secondsSpent = 0
    var hintAvailable = false
    var hint: HintType? = nil
    
    private var undoManager: UndoManager?

    init(_ level: Level) {
        self.level = level
        // Create mutable game cells from immutable level cells
        let cells = level.levelCells.map { row in
            row.map { levelCell in
                GameCell(predefinedValue: levelCell.predefinedValue)
            }
        }
        // Convert 2D array to flat array
        self.gameCells = cells.flatMap { $0 }
        isSolved = checkIsSolved()
        isMistake = !isFieldValid()
        mistakes = getMistakes()
    }
    
    // TODO: test
    // looking for mistake with this row and column
    func isMistakeCell(i: Int, j: Int) -> Bool {
        return mistakes.contains { mistake in
            mistake.cells.contains { cell in
                cell.row == i && cell.column == j
            }
        }
    }
    
    func setUndoManager(_ undoManager: UndoManager?) {
        self.undoManager = undoManager
    }
    
    // Helper methods for 2D access
    func cell(at row: Int, column: Int) -> GameCell {
        return gameCells[cellIndex(row: row, column: column)]
    }
    
    func cellIndex(row: Int, column: Int) -> Int {
        return row * level.lineLength + column
    }
    
    func row(_ rowIndex: Int) -> [GameCell] {
        let startIndex = rowIndex * level.lineLength
        return Array(gameCells[startIndex..<startIndex + level.lineLength])
    }
    
    func column(_ columnIndex: Int) -> [GameCell] {
        return (0..<level.lineLength).map { gameCells[cellIndex(row: $0, column: columnIndex)] }
    }
    
    // Access the solved state rows and columns
    func solvedRow(_ rowIndex: Int) -> [CellValue] {
        guard rowIndex < level.solvedCells.count else { return [] }
        return level.solvedCells[rowIndex]
    }
    
    func solvedColumn(_ columnIndex: Int) -> [CellValue] {
        guard !level.solvedCells.isEmpty else { return [] }
        guard columnIndex < level.solvedCells[0].count else { return [] }
        return (0..<level.solvedCells.count).map { level.solvedCells[$0][columnIndex] }
    }

    func isRowValid(_ row: Int) -> Bool {
        let rowArray = self.row(row)
        let conditions = gameConditions.filter { $0.cellA.row == row && $0.cellB.row == row}
        return isCellsArrayValid(rowArray, conditions)
    }

    func isColumnValid(_ column: Int) -> Bool {
        let columnArray = self.column(column)
        let conditions = gameConditions
            .filter { $0.cellA.column == column && $0.cellB.column == column}
            .map { GameCellCondition(condition: $0.condition, cellA: CellPosition(row: $0.cellA.column, column: $0.cellA.row), cellB: CellPosition(row: $0.cellB.column, column: $0.cellB.row)) }
        return isCellsArrayValid(columnArray, conditions)
    }

    func isFieldValid() -> Bool {
        let isRowsValid = (0..<level.lineLength).map { isRowValid($0) }.allSatisfy { $0 }
        let isColumnsValid = (0..<level.lineLength).map { isColumnValid($0) }.allSatisfy { $0 }
        return isRowsValid && isColumnsValid
    }

    func checkIsSolved() -> Bool {
        let isAllCellsFilled = gameCells.allSatisfy { $0.value != nil || $0.predefinedValue != nil}
        return isAllCellsFilled && isFieldValid()
    }

    private func isCellsArrayValid(_ cells: [GameCell], _ conditions: [GameCellCondition]) -> Bool {
        let zeroes = cells.count { $0.value == .zero }
        let ones = cells.count { $0.value == .one }

        // count of 0 and 1
        guard
            zeroes <= lineLength / 2,
            ones <= lineLength / 2
        else {
            return false
        }

        // no more than 2 after each other
        var zeroesCount = 0
        var onesCount = 0
        for cell in cells {
            if cell.value == .zero {
                zeroesCount += 1
                onesCount = 0
            }
            if cell.value == .one {
                zeroesCount = 0
                onesCount += 1
            }
            if cell.value == nil {
                zeroesCount = 0
                onesCount = 0
            }
            guard zeroesCount <= 2 && onesCount <= 2 else { return false }
        }

        // check conditions
        for condition in conditions {
            // For row conditions, we use column as the index
            let cellA = cells[condition.cellA.column]
            let cellB = cells[condition.cellB.column]
            guard cellA.value != nil && cellB.value != nil else { continue }

            if condition.condition == .equal && cellA.value != cellB.value {
                return false
            }

            if condition.condition == .opposite && cellA.value == cellB.value {
                return false
            }
        }

        return true
    }
    
    func toggleCell(_ i: Int, _ j: Int) {
        let index = cellIndex(row: i, column: j)
        let cell = gameCells[index]
        guard cell.predefinedValue == nil else { return }
        
        let oldValue = cell.value
        
        undoManager?.registerUndo(withTarget: self) { [weak self] target in
            guard let self else { return }
            
            target.setCellValue(at: i, column: j, value: oldValue)
            
            undoManager?.registerUndo(withTarget: target) { redoTarget in
                target.toggleCell(i, j)
            }
        }

        if cell.value == nil {
            gameCells[index].value = .zero
        }
        else if cell.value == .zero {
            gameCells[index].value = .one
        }
        else {
            gameCells[index].value = nil
        }
        
        isSolved = checkIsSolved()
        isMistake = !isFieldValid()
        mistakes = getMistakes()
        
//        let mistakeId = UUID()
//        mistakeValidationID = mistakeId
//        isMistake = false
        
//        Task {
//            try await Task.sleep(for: .seconds(1))
//            await validateMistake(mistakeId)
//        }
    }
    
    func clearField() {
        let oldCells = gameCells
        
        undoManager?.registerUndo(withTarget: self) { [weak self] target in
            guard let self else { return }
            
            resetField(with: oldCells)
            
            undoManager?.registerUndo(withTarget: self) { redoTarget in
                redoTarget.clearField()
            }
        }
        
        resetField(with: gameCells.cleared())
    }
    
    func resetField(with cells: [GameCell]) {
        gameCells = cells
        isSolved = checkIsSolved()
        isMistake = !isFieldValid()
        mistakes = getMistakes()
    }
    
    func setCellValue(at row: Int, column: Int, value: CellValue?) {
        let index = cellIndex(row: row, column: column)
        gameCells[index].value = value
        
        isSolved = checkIsSolved()
        isMistake = !isFieldValid()
        mistakes = getMistakes()
    }
}
