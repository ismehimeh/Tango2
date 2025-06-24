//
//  StubData.swift
//  Tango
//
//  Created by Sergei Vasilenko on 10.03.2025.
//

// MARK: - Level 1
let level1Cells: [[GameCell]] = [
    // 1
    [GameCell(), GameCell(), GameCell(predefinedValue: .zero), GameCell(), GameCell(), GameCell()],
    // 2
    [GameCell(), GameCell(predefinedValue: .one), GameCell(predefinedValue: .one), GameCell(), GameCell(), GameCell()],
    // 3
    [GameCell(predefinedValue: .one), GameCell(predefinedValue: .one), GameCell(), GameCell(), GameCell(), GameCell()],
    // 4
    [GameCell(), GameCell(), GameCell(), GameCell(), GameCell(predefinedValue: .one), GameCell(predefinedValue: .zero)],
    // 5
    [GameCell(), GameCell(), GameCell(), GameCell(predefinedValue: .one), GameCell(predefinedValue: .zero), GameCell()],
    // 6
    [GameCell(), GameCell(), GameCell(), GameCell(predefinedValue: .zero), GameCell(), GameCell()],
]

let level1Conditions: [GameCellCondition] = [
    .init(condition: .opposite, cellA: CellPosition(row: 0, column: 4), cellB: CellPosition(row: 0, column: 5)),
    .init(condition: .opposite, cellA: CellPosition(row: 0, column: 5), cellB: CellPosition(row: 1, column: 5)),
    .init(condition: .equal, cellA: CellPosition(row: 4, column: 0), cellB: CellPosition(row: 5, column: 0)),
    .init(condition: .equal, cellA: CellPosition(row: 5, column: 0), cellB: CellPosition(row: 5, column: 1)),
]

let level1 = Level(title: "1", gameCells: level1Cells, gameConditions: level1Conditions)

// MARK:  - Level 2
let level2Cells: [[GameCell]] = [
    // 1
    [GameCell(), GameCell(), GameCell(), GameCell(), GameCell(), GameCell()],
    // 2
    [GameCell(), GameCell(predefinedValue: .one), GameCell(), GameCell(predefinedValue: .zero), GameCell(predefinedValue: .one), GameCell()],
    // 3
    [GameCell(), GameCell(predefinedValue: .zero), GameCell(), GameCell(), GameCell(), GameCell()],
    // 4
    [GameCell(), GameCell(), GameCell(), GameCell(), GameCell(predefinedValue: .zero), GameCell()],
    // 5
    [GameCell(), GameCell(predefinedValue: .one), GameCell(predefinedValue: .zero), GameCell(), GameCell(predefinedValue: .zero), GameCell()],
    // 6
    [GameCell(), GameCell(), GameCell(), GameCell(), GameCell(), GameCell()],
]

let level2Conditions: [GameCellCondition] = [
    .init(condition: .equal, cellA: CellPosition(row: 0, column: 2), cellB: CellPosition(row: 0, column: 3)),
    .init(condition: .opposite, cellA: CellPosition(row: 0, column: 4), cellB: CellPosition(row: 0, column: 5)),
    .init(condition: .opposite, cellA: CellPosition(row: 1, column: 0), cellB: CellPosition(row: 2, column: 0)),
    .init(condition: .equal, cellA: CellPosition(row: 3, column: 5), cellB: CellPosition(row: 4, column: 5)),
    .init(condition: .equal, cellA: CellPosition(row: 5, column: 0), cellB: CellPosition(row: 5, column: 1)),
    .init(condition: .opposite, cellA: CellPosition(row: 5, column: 2), cellB: CellPosition(row: 5, column: 3)),
]

let level2 = Level(title: "2", gameCells: level2Cells, gameConditions: level2Conditions)


// MARK: - Level 3
//basically, it is almost solved level 1
let level3Cells: [[GameCell]] = [
    // 1
    [GameCell(predefinedValue: .one), GameCell(), GameCell(predefinedValue: .zero), GameCell(predefinedValue: .one), GameCell(predefinedValue: .one), GameCell(predefinedValue: .zero)],
    // 2
    [GameCell(predefinedValue: .zero), GameCell(predefinedValue: .one), GameCell(predefinedValue: .one), GameCell(predefinedValue: .zero), GameCell(predefinedValue: .zero), GameCell(predefinedValue: .one)],
    // 3
    [GameCell(predefinedValue: .one), GameCell(predefinedValue: .one), GameCell(predefinedValue: .zero), GameCell(predefinedValue: .one), GameCell(predefinedValue: .zero), GameCell(predefinedValue: .zero)],
    // 4
    [GameCell(predefinedValue: .one), GameCell(predefinedValue: .zero), GameCell(predefinedValue: .one), GameCell(predefinedValue: .zero), GameCell(predefinedValue: .one), GameCell(predefinedValue: .zero)],
    // 5
    [GameCell(predefinedValue: .zero), GameCell(predefinedValue: .one), GameCell(predefinedValue: .zero), GameCell(predefinedValue: .one), GameCell(predefinedValue: .zero), GameCell(predefinedValue: .one)],
    // 6
    [GameCell(predefinedValue: .zero), GameCell(predefinedValue: .zero), GameCell(predefinedValue: .one), GameCell(predefinedValue: .zero), GameCell(predefinedValue: .one), GameCell(predefinedValue: .one)],
]

let level3Conditions: [GameCellCondition] = [
    .init(condition: .opposite, cellA: CellPosition(row: 0, column: 4), cellB: CellPosition(row: 0, column: 5)),
    .init(condition: .opposite, cellA: CellPosition(row: 0, column: 5), cellB: CellPosition(row: 1, column: 5)),
    .init(condition: .equal, cellA: CellPosition(row: 4, column: 0), cellB: CellPosition(row: 5, column: 0)),
    .init(condition: .equal, cellA: CellPosition(row: 5, column: 0), cellB: CellPosition(row: 5, column: 1)),
]

let level3 = Level(title: "3", gameCells: level3Cells, gameConditions: level3Conditions)
