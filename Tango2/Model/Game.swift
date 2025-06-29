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
    private(set) var lineLength = 6 // Standard game board size
    
    var gameCells: [GameCell]
    
    var gameConditions: [GameCellCondition] {
        level.gameConditions
    }
    var isSolved = false
    var isMistake = false
    var mistakes = [MistakeType]()
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
    
    // MARK: - Public Mistake Detection Methods
    
    /// Get all mistakes across the entire board
    func getMistakes() -> [MistakeType] {
        var allMistakes = Set<MistakeType>()
        
        // Check all rows
        for rowIndex in 0..<level.gameCells.count {
            allMistakes.formUnion(getMistakes(forRowWithIndex: rowIndex))
        }
        
        // Check all columns
        for columnIndex in 0..<level.gameCells[0].count {
            allMistakes.formUnion(getMistakes(forColumnWithIndex: columnIndex))
        }
        
        return Array(allMistakes.sorted(by: { $0.description < $1.description }))
    }
    
    /// Get mistakes for a specific row
    func getMistakes(forRowWithIndex rowIndex: Int) -> [MistakeType] {
        var mistakes = [MistakeType]()
        
        // Check for sign violations in this row
        mistakes += checkSignViolation(
            cells: row(rowIndex),
            isRow: true,
            index: rowIndex
        )
        
        // Check for no more than 2 consecutive same values
        mistakes += checkNoMoreThan2(cells: row(rowIndex))
        
        // Check for equal number of zeros and ones
        mistakes += checkSameNumberValues(cells: row(rowIndex))
        
        return mistakes
    }
    
    /// Get mistakes for a specific column
    func getMistakes(forColumnWithIndex columnIndex: Int) -> [MistakeType] {
        var mistakes = [MistakeType]()
        
        // Check for sign violations in this column
        mistakes += checkSignViolation(
            cells: column(columnIndex),
            isRow: false,
            index: columnIndex
        )
        
        // Check for no more than 2 consecutive same values
        mistakes += checkNoMoreThan2(cells: column(columnIndex))
        
        // Check for equal number of zeros and ones
        mistakes += checkSameNumberValues(cells: column(columnIndex))
        
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
    private func checkSignViolation(cells: [GameCell], isRow: Bool, index: Int) -> [MistakeType] {
        var mistakes = [MistakeType]()
        
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
                    mistakes.append(.signViolation(.equal))
                }
            case .opposite:
                if cellAValue == cellBValue {
                    mistakes.append(.signViolation(.opposite))
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
    private func checkNoMoreThan2(cells: [GameCell]) -> [MistakeType] {
        var mistakes = [MistakeType]()
        
        // Check for more than 2 consecutive same values
        var consecutiveZeroes = 0
        var consecutiveOnes = 0
        
        for cell in cells {
            if cell.value == .zero {
                consecutiveZeroes += 1
                consecutiveOnes = 0
            } else if cell.value == .one {
                consecutiveZeroes = 0
                consecutiveOnes += 1
            } else {
                // nil value resets both counters
                consecutiveZeroes = 0
                consecutiveOnes = 0
            }
            
            // If we find more than 2 consecutive same values, add the mistake
            if consecutiveZeroes > 2 || consecutiveOnes > 2 {
                mistakes.append(.noMoreThan2)
                break // Only add this mistake once per line
            }
        }
        
        return mistakes
    }
    
    /**
     Checks if a completely filled line has an equal number of zeros and ones.
     
     - Parameter cells: Array of cells to check
     - Returns: Array of mistake types found
     */
    private func checkSameNumberValues(cells: [GameCell]) -> [MistakeType] {
        var mistakes = [MistakeType]()
        
        // Count zeroes, ones, and nil values
        let zeroCount = cells.filter { $0.value == .zero }.count
        let oneCount = cells.filter { $0.value == .one }.count
        let nilCount = cells.filter { $0.value == nil }.count
        
        // Only check for balance in completely filled lines (no nil values)
        if nilCount == 0 {
            // Check if number of zeros equals number of ones
            if zeroCount != oneCount {
                mistakes.append(.sameNumberValues)
            }
        }
        
        return mistakes
    }
}
