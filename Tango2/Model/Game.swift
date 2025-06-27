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
    var secondsSpent = 0

    init(_ level: Level) {
        self.level = level
        // Convert 2D array to flat array
        self.gameCells = level.gameCells.flatMap { $0 }
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
    
    func toogleCell(_ i: Int, _ j: Int) {
        let index = cellIndex(row: i, column: j)
        let cell = gameCells[index]
        guard cell.predefinedValue == nil else { return }

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
        
//        let mistakeId = UUID()
//        mistakeValidationID = mistakeId
//        isMistake = false
        
//        Task {
//            try await Task.sleep(for: .seconds(1))
//            await validateMistake(mistakeId)
//        }
    }
    
    func clearField() {
        gameCells = gameCells.map { cell in
            GameCell(predefinedValue: cell.predefinedValue)
        }
    }
}
