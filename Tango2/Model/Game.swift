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
    // 1. Holds one game state (isSolved, isMistake, secondsSpent)
    // 2. Orchestrates field changes and reponse for them
    // 3. Holds and provides solved level data

    let currentLevel: Level

    var lineLength: Int {
        cellsStore.lineLength
    }

    var gameConditions: [Condition] {
        currentLevel.gameConditions
    }

    var isSolved = true
    var isMistake = false
    var mistakes = [Mistake]()
    var secondsSpent = 0

    private let cellsStore: FieldStore
    private var cancellables = Set<AnyCancellable>()
    private let validatorService: ValidatorServiceProtocol
    private let mistakeService: MistakeServiceProtocol
    private let hintService: HintServiceProtocol

    init(_ level: Level,
         validatorService: ValidatorServiceProtocol = ValidatorService(),
         mistakeService: MistakeServiceProtocol = MistakeService(),
         hintService: HintServiceProtocol = HintService())
    {
        self.currentLevel = level
        self.validatorService = validatorService
        self.mistakeService = mistakeService
        self.hintService = hintService

        // Create mutable game cells from immutable level cells
        let cells = level.levelCells.map { row in
            row.map { levelCell in
                GameCell(predefinedValue: levelCell.predefinedValue)
            }
        }

        // Convert 2D array to flat array
        self.cellsStore = FieldStore(cells.flatMap { $0 },
                                     lineLength: level.lineLength)

        validatorService.dataSource = self
        mistakeService.dataSource = self
        hintService.dataSource = self

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
        isMistake = !validatorService.isFieldValid()
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

    func isMistakeCell(row: Int, column: Int) -> Bool {
        return mistakes.contains { mistake in
            mistake.cells.contains { cell in
                cell.row == row && cell.column == column
            }
        }
    }
}

extension Game {

    func checkIsSolved() -> Bool {
        let isAllCellsFilled = cellsStore.cells.allSatisfy { $0.value != nil || $0.predefinedValue != nil}
        return isAllCellsFilled && validatorService.isFieldValid()
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

    func toggleCell(_ row: Int, _ column: Int) {
        cellsStore.toggleCell(row, column)
    }

    func cell(at row: Int, column: Int) -> GameCell {
        cellsStore.cell(at: row, column: column)
    }

    func clearField() {
        cellsStore.clearField()
    }
}

// MARK: MistakeService
extension Game {

    func getMistakes() -> [Mistake] {
        mistakeService.getMistakes()
    }

    func getMistakes(forRowWithIndex rowIndex: Int) -> [Mistake] {
        mistakeService.getMistakes(forRowWithIndex: rowIndex)
    }

    func getMistakes(forColumnWithIndex columnIndex: Int) -> [Mistake] {
        mistakeService.getMistakes(forColumnWithIndex: columnIndex)
    }
}

// MARK: MistakeServiceDataSource & HintServiceDataSource
extension Game: MistakeServiceDataSource, HintServiceDataSource, ValidatorServiceDataSource {

    func level() -> Level {
        currentLevel
    }

    func conditions() -> [Condition] {
        gameConditions
    }

    func row(_ rowIndex: Int) -> [GameCell] {
        cellsStore.row(rowIndex)
    }

    func column(_ columnIndex: Int) -> [GameCell] {
        cellsStore.column(columnIndex)
    }

    func solvedRow(_ rowIndex: Int) -> [CellValue] {
        guard
            rowIndex < currentLevel.solvedCells.count
        else {
            return []
        }

        return currentLevel.solvedCells[rowIndex]
    }

    func solvedColumn(_ columnIndex: Int) -> [CellValue] {
        guard
            !currentLevel.solvedCells.isEmpty,
            columnIndex < currentLevel.solvedCells[0].count
        else {
            return []
        }

        return (0..<currentLevel.solvedCells.count).map { currentLevel.solvedCells[$0][columnIndex] }
    }
}

// MARK: Hints
extension Game {

    func getHint() -> Hint? {
        hintService.getHint()
    }
}
