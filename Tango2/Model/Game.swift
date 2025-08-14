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
    // Responsibilities of Game
    // 1. Generates hints
    // 2. Generate mistakes
    // 3. Holds one game state (isSolved, isMistake, secondsSpent)
    // 4. Orchestrates field changes and reponse for them
    // 5. Holds and provides solved level data

    let currentLevel: Level
    
    var lineLength: Int {
        cellsStore.lineLength
    }
    
    var gameConditions: [GameCellCondition] {
        currentLevel.gameConditions
    }
    
    var isSolved = true
    var isMistake = false
    var mistakes = [Mistake]()
    var secondsSpent = 0
    
    private let cellsStore: CellsStore
    private var cancellables = Set<AnyCancellable>()
    private let fieldValidator: FieldValidatorProtocol
    private let mistakeService: MistakeServiceProtocol

    init(_ level: Level,
         fieldValidator: FieldValidatorProtocol = DefaultFieldValidator(),
         mistakeService: MistakeServiceProtocol = MistakeService())
    {
        self.currentLevel = level
        self.fieldValidator = fieldValidator
        self.mistakeService = mistakeService
        
        // Create mutable game cells from immutable level cells
        let cells = level.levelCells.map { row in
            row.map { levelCell in
                GameCell(predefinedValue: levelCell.predefinedValue)
            }
        }
        
        // Convert 2D array to flat array
        self.cellsStore = CellsStore(cells.flatMap { $0 },
                                     lineLength: level.lineLength)
        mistakeService.dataSource = self
        
        refreshGame()
        bind()
    }
    
    private func bind() {
        cellsStore
            .fieldNeedsRevalidation
            .sink(receiveValue: refreshGame)
            .store(in: &cancellables)
    }
    
    private func refreshGame() {
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
    
    func isMistakeCell(i: Int, j: Int) -> Bool {
        return mistakes.contains { mistake in
            mistake.cells.contains { cell in
                cell.row == i && cell.column == j
            }
        }
    }
}

// MARK: Access the solved state rows and columns
extension Game {
    
    func solvedRow(_ rowIndex: Int) -> [CellValue] {
        guard rowIndex < currentLevel.solvedCells.count else { return [] }
        return currentLevel.solvedCells[rowIndex]
    }
    
    func solvedColumn(_ columnIndex: Int) -> [CellValue] {
        guard !currentLevel.solvedCells.isEmpty else { return [] }
        guard columnIndex < currentLevel.solvedCells[0].count else { return [] }
        return (0..<currentLevel.solvedCells.count).map { currentLevel.solvedCells[$0][columnIndex] }
    }

    func checkIsSolved() -> Bool {
        let isAllCellsFilled = cellsStore.cells.allSatisfy { $0.value != nil || $0.predefinedValue != nil}
        return isAllCellsFilled && isFieldValid()
    }
}

// MARK: Validity check
extension Game {
    
    func isRowValid(_ index: Int) -> Bool {
        let rowArray = cellsStore.row(index)
        let conditions = gameConditions.filter { $0.cellA.row == index && $0.cellB.row == index}
        return fieldValidator.isCellsArrayValid(rowArray, conditions, lineLength: lineLength)
    }

    func isColumnValid(_ column: Int) -> Bool {
        let columnArray = cellsStore.column(column)
        let conditions = gameConditions
            .filter { $0.cellA.column == column && $0.cellB.column == column}
            .map { GameCellCondition(condition: $0.condition, cellA: CellPosition(row: $0.cellA.column, column: $0.cellA.row), cellB: CellPosition(row: $0.cellB.column, column: $0.cellB.row)) }
        return fieldValidator.isCellsArrayValid(columnArray, conditions, lineLength: lineLength)
    }

    func isFieldValid() -> Bool {
        let isRowsValid = (0..<lineLength).map { isRowValid($0) }.allSatisfy { $0 }
        let isColumnsValid = (0..<lineLength).map { isColumnValid($0) }.allSatisfy { $0 }
        return isRowsValid && isColumnsValid
    }
}

// MARK: Passing actions to cellsStore
extension Game {
    
    func setUndoManager(_ undoManager: UndoManagerProtocol?) {
        cellsStore.setUndoManager(undoManager)
    }
    
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

extension Game: MistakeServiceDataSource {
    func level() -> Level {
        return currentLevel
    }
    
    func conditions() -> [GameCellCondition] {
        return gameConditions
    }
    
    func row(_ rowIndex: Int) -> [GameCell] {
        return cellsStore.row(rowIndex)
    }
    
    func column(_ columnIndex: Int) -> [GameCell] {
        return cellsStore.column(columnIndex)
    }
}
