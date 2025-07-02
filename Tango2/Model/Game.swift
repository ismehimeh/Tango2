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
    let lineLength = 6 // Standard game board size
    
    var gameCells: [GameCell]
    
    var gameConditions: [GameCellCondition] {
        level.gameConditions
    }
    var isSolved = false
    var isMistake = false
    var mistakes = [Mistake]()
    var secondsSpent = 0
    
    private var undoManager: UndoManager?

    init(_ level: Level) {
        self.level = level
        // Convert 2D array to flat array
        self.gameCells = level.gameCells.flatMap { $0 }
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
        return row * lineLength + column
    }
    
    func row(_ rowIndex: Int) -> [GameCell] {
        let startIndex = rowIndex * lineLength
        return Array(gameCells[startIndex..<startIndex + lineLength])
    }
    
    func column(_ columnIndex: Int) -> [GameCell] {
        return (0..<lineLength).map { gameCells[cellIndex(row: $0, column: columnIndex)] }
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
        let isRowsValid = (0..<lineLength).map { isRowValid($0) }.allSatisfy { $0 }
        let isColumnsValid = (0..<lineLength).map { isColumnValid($0) }.allSatisfy { $0 }
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
            zeroes <= 3,
            ones <= 3
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

// - MARK: Mistakes
extension Game {
    
    func getMistakes() -> [Mistake] {
        var allMistakes = [Mistake]()
        
        // Check all rows
        for rowIndex in 0..<level.gameCells.count {
            allMistakes.append(contentsOf: getMistakes(forRowWithIndex: rowIndex))
        }
        
        // Check all columns
        for columnIndex in 0..<level.gameCells[0].count {
            allMistakes.append(contentsOf: getMistakes(forColumnWithIndex: columnIndex))
        }
        
        return allMistakes
    }
    
    func getMistakes(forRowWithIndex rowIndex: Int) -> [Mistake] {
        var mistakes = [Mistake]()
        mistakes.append(contentsOf: checkSignViolation(cells: row(rowIndex), isRow: true, index: rowIndex))
        mistakes.append(contentsOf: checkSameNumberValues(cells: row(rowIndex), isRow: true, index: rowIndex))
        mistakes.append(contentsOf: checkNoMoreThan2(cells: row(rowIndex), isRow: true, index: rowIndex))
        return mistakes
    }
    
    func getMistakes(forColumnWithIndex columnIndex: Int) -> [Mistake] {
        var mistakes = [Mistake]()
        mistakes.append(contentsOf: checkSignViolation(cells: column(columnIndex), isRow: false, index: columnIndex))
        mistakes.append(contentsOf: checkSameNumberValues(cells: column(columnIndex), isRow: false, index: columnIndex))
        mistakes.append(contentsOf: checkNoMoreThan2(cells: row(columnIndex), isRow: false, index: columnIndex))
        return mistakes
    }
    
    // MARK: - Private Helper Methods for Mistake Detection
    
    /**
     Checks for sign violations between cells based on game conditions.
     
     - Parameters:
       - cells: Array of cells to check (either a row or column)
       - isRow: True if checking a row, false if checking a column
       - index: The index of the row or column being checked
     - Returns: Array of mistake types found
     */
    private func checkSignViolation(cells: [GameCell], isRow: Bool, index: Int) -> [Mistake] {
        var mistakes = [Mistake]()
        
        // Filter conditions that apply to this row/column
        let relatedConditions = gameConditions.filter {
            if isRow {
                return $0.cellA.row == index && $0.cellB.row == index
            } else {
                return $0.cellA.column == index && $0.cellB.column == index
            }
        }
        
        relatedConditions.forEach { condition in
            let positionA = isRow ? condition.cellA.column : condition.cellA.row
            let positionB = isRow ? condition.cellB.column : condition.cellB.row
            
            let cellAValue = cells[positionA].value
            let cellBValue = cells[positionB].value
            
            guard cellAValue != nil && cellBValue != nil else { return }
            
            switch condition.condition {
            case .equal:
                if cellAValue != cellBValue {
                    mistakes.append(.init(cells: [condition.cellA, condition.cellB],
                                          type: .signViolation(.equal)))
                }
            case .opposite:
                if cellAValue == cellBValue {
                    mistakes.append(.init(cells: [condition.cellA, condition.cellB],
                                          type: .signViolation(.opposite)))
                }
            }
        }
        
        return mistakes
    }
    
    /**
     Checks for more than 2 consecutive identical values in a line of cells.
     
     - Parameter cells: Array of cells to check
     - Returns: Array of mistake types found
     */
    private func checkNoMoreThan2(cells: [GameCell], isRow: Bool, index: Int) -> [Mistake] {
        var mistakes = [Mistake]()
        
        // check for zeros
        // check for ones
        return mistakes
    }
    
    // we have line of length 6
    // so there could be only 2 mistaked sequence of different symbols (000111 where 000 and 111 are mistakes) per line
    // or just one sequence per line (010111, 001111, 111111)
    // that is why we return single optional tuple instead of array
    static func checkNoMoreThan2(of target: CellValue, in array: [CellValue?]) -> (Int, Int)? {
        var startIndex = -1
        var sequenceLength = 0
        for i in 0..<array.count {
            // not nil
            if let value = array[i] {
                if startIndex >= 0 {
                    if value == target {
                        sequenceLength += 1
                    }
                    else {
                        if sequenceLength > 2 {
                            return (startIndex, startIndex + sequenceLength - 1)
                        }
                    }
                }
                else {
                    if value == target {
                        sequenceLength += 1
                        startIndex = i
                    }
                    else {
                        if sequenceLength > 2 {
                            return (startIndex, startIndex + sequenceLength - 1)
                        }
                    }
                }
            }
            // nil
            else {
                // if we started to track sequence
                if startIndex >= 0 {
                    if sequenceLength > 2 {
                        return (startIndex, startIndex + sequenceLength - 1)
                    }
                }
            }
        }
        
        if startIndex >= 0 {
            if sequenceLength > 2 {
                return (startIndex, startIndex + sequenceLength - 1)
            }
        }
        
        return nil
    }
    
    /**
     Checks if a completely filled line has an equal number of zeros and ones.
     
     - Parameter cells: Array of cells to check
     - Returns: Array of mistake types found
     */
    private func checkSameNumberValues(cells: [GameCell], isRow: Bool, index: Int) -> [Mistake] {
        var mistakes = [Mistake]()
        
        // Count zeroes, ones, and nil values
        let zeroCount = cells.filter { $0.value == .zero }.count
        let oneCount = cells.filter { $0.value == .one }.count
        let nilCount = cells.filter { $0.value == nil }.count
        
        // Only check for balance in completely filled lines (no nil values)
        if nilCount == 0 {
            // Check if number of zeros equals number of ones
            if zeroCount != oneCount {
                let cells = (0..<cells.count).map {
                    CellPosition(row: isRow ? index : $0, column: isRow ? $0 : index)
                }
                mistakes.append(.init(cells: cells, type: .sameNumberValues))
            }
        }
        
        return mistakes
    }
}
