//
//  Level.swift
//  Tango
//
//  Created by Sergei Vasilenko on 14.03.2025.
//

import Foundation

struct Level: Identifiable, Hashable {
    let id = UUID()
    let title: String // TODO: I am not planning to use it, just need it to distinguish cell for now
    let lineLength: Int
    let gameCells: [[GameCell]]
    let gameConditions: [GameCellCondition]
    let solvedCells: [[CellValue]]
    
    /// Factory method to create a Level with a more concise syntax
    /// - Parameters:
    ///   - title: Level title
    ///   - boardDefinition: 2D array where nil = empty cell, .zero or .one for predefined values
    ///   - conditions: Array of tuples defining conditions between cells
    /// - Returns: A new Level instance
    static func create(title: String,
                       lineLength: Int = 6,
                       boardDefinition: [[CellValue?]],
                       conditions: [(condition: GameCellCondition.Condition,
                                     position1: (row: Int, col: Int),
                                     position2: (row: Int, col: Int))],
                       solvedCells: [[CellValue]] = []) -> Level
    {
        // Convert simple board definition to GameCells
        let gameCells = boardDefinition.map { row in
            row.map { value in
                if let predefinedValue = value {
                    return GameCell(predefinedValue: predefinedValue)
                } else {
                    return GameCell()
                }
            }
        }
        
        // Convert simple conditions to GameCellConditions
        let gameConditions = conditions.map { cond in
            GameCellCondition(condition: cond.condition,
                              cellA: CellPosition(row: cond.position1.row,
                                                  column: cond.position1.col),
                              cellB: CellPosition(row: cond.position2.row,
                                                  column: cond.position2.col))
        }
        
        return Level(title: title,
                     lineLength: lineLength,
                     gameCells: gameCells,
                     gameConditions: gameConditions,
                     solvedCells: solvedCells)
    }
}
