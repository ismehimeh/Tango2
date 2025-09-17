//
//  Level.swift
//  Tango
//
//  Created by Sergei Vasilenko on 14.03.2025.
//

import Foundation
import SwiftData

@Model
class Level: Identifiable {
    var id = UUID()
    var title: String // TODO: I am not planning to use it, just need it to distinguish cell for now
    var lineLength: Int
    var levelCells: [[LevelCell]]
    var gameConditions: [Condition]
    var solvedCells: [[CellValue]]

    init(title: String,
         lineLength: Int,
         levelCells: [[LevelCell]],
         gameConditions: [Condition],
         solvedCells: [[CellValue]])
    {
        self.title = title
        self.lineLength = lineLength
        self.levelCells = levelCells
        self.gameConditions = gameConditions
        self.solvedCells = solvedCells
    }

    /// Factory method to create a Level with a more concise syntax
    /// - Parameters:
    ///   - title: Level title
    ///   - boardDefinition: 2D array where nil = empty cell, .zero or .one for predefined values
    ///   - conditions: Array of tuples defining conditions between cells
    /// - Returns: A new Level instance
    static func create(title: String,
                       lineLength: Int = 6,
                       boardDefinition: [[CellValue?]],
                       conditions: [(condition: Condition.Sign,
                                     position1: (row: Int, col: Int),
                                     position2: (row: Int, col: Int))],
                       solvedCells: [[CellValue]] = []) -> Level
    {
        // Convert simple board definition to LevelCells
        let levelCells = boardDefinition.map { row in
            row.map { value in
                if let predefinedValue = value {
                    return LevelCell(predefinedValue: predefinedValue)
                } else {
                    return LevelCell()
                }
            }
        }

        // Convert simple conditions to GameCellConditions
        let gameConditions = conditions.map { cond in
            Condition(condition: cond.condition,
                              cellA: CellPosition(row: cond.position1.row,
                                                  column: cond.position1.col),
                              cellB: CellPosition(row: cond.position2.row,
                                                  column: cond.position2.col))
        }

        return Level(title: title,
                     lineLength: lineLength,
                     levelCells: levelCells,
                     gameConditions: gameConditions,
                     solvedCells: solvedCells)
    }
}

extension Level: Equatable {
    static func == (lhs: Level, rhs: Level) -> Bool {
        lhs.id == rhs.id
    }
}

extension Level: Hashable {

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
