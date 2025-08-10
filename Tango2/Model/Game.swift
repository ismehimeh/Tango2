//
//  Game.swift
//  Tango
//
//  Created by Sergei Vasilenko on 11.03.2025.
//

import Combine
import Foundation

@Observable
class Game {

    let level: Level
    
    var lineLength: Int {
        level.lineLength
    }
    
    var gameConditions: [GameCellCondition] {
        level.gameConditions
    }
    
    var isSolved = true
    var isMistake = false
    var mistakes = [Mistake]()
    var secondsSpent = 0
    
    let cellsStore: CellsStore
    private var cancellables = Set<AnyCancellable>()

    init(_ level: Level) {
        self.level = level
        // Create mutable game cells from immutable level cells
        let cells = level.levelCells.map { row in
            row.map { levelCell in
                GameCell(predefinedValue: levelCell.predefinedValue)
            }
        }
        // Convert 2D array to flat array
        self.cellsStore = CellsStore(cells.flatMap { $0 },
                                     lineLength: level.lineLength)
        
        validateField()
        bind()
    }
    
    private func bind() {
        cellsStore
            .fieldNeedsRevalidation
            .sink(receiveValue: validateField)
            .store(in: &cancellables)
    }
    
    private func validateField() {
        isSolved = checkIsSolved()
        isMistake = !isFieldValid()
        mistakes = getMistakes()
        
        // TODO: this code related to delayed mistake indication and was used only on toggle cell, not on every field change
//        let mistakeId = UUID()
//        mistakeValidationID = mistakeId
//        isMistake = false
        
//        Task {
//            try await Task.sleep(for: .seconds(1))
//            await validateMistake(mistakeId)
//        }
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
    
    func setUndoManager(_ undoManager: UndoManagerProtocol?) {
        cellsStore.setUndoManager(undoManager)
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

    func isRowValid(_ index: Int) -> Bool {
        let rowArray = cellsStore.row(index)
        let conditions = gameConditions.filter { $0.cellA.row == index && $0.cellB.row == index}
        return isCellsArrayValid(rowArray, conditions)
    }

    func isColumnValid(_ column: Int) -> Bool {
        let columnArray = cellsStore.column(column)
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
        let isAllCellsFilled = cellsStore.cells.allSatisfy { $0.value != nil || $0.predefinedValue != nil}
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
}

extension Game {
    
    func setCellValue(at row: Int, column: Int, value: CellValue?) {
        cellsStore.setCellValue(at: row, column: column, value: value)
    }
    
    func toggleCell(_ i: Int, _ j: Int) {
        cellsStore.toggleCell(i, j)
    }
    
    func cell(at row: Int, column: Int) -> GameCell {
        cellsStore.cell(at: row, column: column)
    }
    
    func clearField() {
        cellsStore.clearField()
    }
}
