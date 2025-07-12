//
//  Game+Hints.swift
//  Tango2
//
//  Created by Sergei Vasilenko on 10.07.2025.
//

// - MARK: Mistakes
extension Game {
    
    func getHint() -> Hint? {
        
        // First check exclusively for incorrectCell hints
        for rowIndex in 0..<level.gameCells.count {
            if let hint = getHint(forRowWithIndex: rowIndex) {
                return hint
            }
        }
        
        for columnIndex in 0..<level.gameCells[0].count {
            if let hint = getHint(forColumnWithIndex: columnIndex) {
                return hint
            }
        }
        
        // Start checking getNoMoreThan2Hint
        return nil
    }
    
    func getHint(forRowWithIndex rowIndex: Int) -> Hint? {
        let row = row(rowIndex).map { $0.value }
        
        if let hint = Game.getIncorrectCellHint(for: row, with: solvedRow(rowIndex)) {
            return Hint(type: hint.type,
                        targetCell: .init(row: rowIndex, column: hint.targetCell.column),
                        relatedCells: hint.relatedCells)
        }
        
        if
            let hint = Game.getOneOptionLeftHint(for: row),
            case let .oneOptionLeft(_, value) = hint.type
        {
                return Hint(type: .oneOptionLeft(lineName: "row",
                                                 value: value),
                            targetCell: .init(row: rowIndex,
                                              column: hint.targetCell.column),
                            relatedCells: hint.relatedCells.map { .init(row: rowIndex, column: $0.column) })
        }
        
        if let hint = Game.getNoMoreThan2Hint(for: row) {
            return Hint(type: hint.type,
                        targetCell: .init(row: rowIndex, column: hint.targetCell.column),
                        relatedCells: hint.relatedCells.map { .init(row: rowIndex, column: $0.column) })
        }
        
        let rowConditions = gameConditions.filter {
            $0.cellA.column != $0.cellB.column && $0.cellA.row == rowIndex
        }.map {
            GameCellCondition(condition: $0.condition,
                              cellA: .init(row: 0, column: $0.cellA.column),
                              cellB: .init(row: 0, column: $0.cellB.column))
        }
        
        if let hint = Game.getSignHint(for: row, with: rowConditions) {
            return Hint(type: hint.type,
                        targetCell: .init(row: rowIndex, column: hint.targetCell.column),
                        relatedCells: hint.relatedCells.map { .init(row: rowIndex, column: $0.column) })
        }
        
        return nil
    }
    
    func getHint(forColumnWithIndex columnIndex: Int) -> Hint? {
        let column = column(columnIndex).map { $0.value }
        
        if let hint = Game.getIncorrectCellHint(for: column, with: solvedColumn(columnIndex)) {
            return Hint(type: hint.type,
                        targetCell: .init(row: hint.targetCell.column, column: columnIndex),
                        relatedCells: hint.relatedCells)
        }
        
        if
            let hint = Game.getOneOptionLeftHint(for: column),
            case let .oneOptionLeft(_, value) = hint.type
        {
                return Hint(type: .oneOptionLeft(lineName: "column",
                                                 value: value),
                            targetCell: .init(row: hint.targetCell.column,
                                              column: columnIndex),
                            relatedCells: hint.relatedCells.map { .init(row: $0.column, column: columnIndex) })
        }
        
        if let hint = Game.getNoMoreThan2Hint(for: column) {
            return Hint(type: hint.type,
                        targetCell: .init(row: hint.targetCell.column, column: columnIndex),
                        relatedCells: hint.relatedCells.map { .init(row: $0.column, column: columnIndex) })
        }
        
        let columnConditions = gameConditions.filter {
            $0.cellA.row != $0.cellB.row && $0.cellA.column == columnIndex
        }.map {
            GameCellCondition(condition: $0.condition,
                              cellA: .init(row: 0, column: $0.cellA.row),
                              cellB: .init(row: 0, column: $0.cellB.row))
        }
        
        if let hint = Game.getSignHint(for: column, with: columnConditions) {
            return Hint(type: hint.type,
                        targetCell: .init(row: hint.targetCell.column,
                                          column: columnIndex),
                        relatedCells: hint.relatedCells.map { .init(row: $0.column, column: columnIndex) })
        }
        
        return nil
    }
}

// MARK: Hints detection
extension Game {
    
    static func getNoMoreThan2Hint(for line: [CellValue?]) -> Hint? {
        
        if let hint = getNoMoreThan2Hint(of: .zero, for: line) {
            return hint
        }
        
        if let hint = getNoMoreThan2Hint(of: .one, for: line) {
            return hint
        }
        
        return nil
    }
    
    static func getIncorrectCellHint(for line: [CellValue?], with correctLine: [CellValue]) -> Hint? {
        guard line.count == correctLine.count else {
            assertionFailure("Something really wrong! Provided 'line' and 'correctLine' differ in length!")
            return nil
        }
        
        for i in 0..<line.count {
            guard let value = line[i] else { continue }
            if value != correctLine[i] {
                return Hint(type: .incorrectCell(value: correctLine[i]), targetCell: .init(row: 0, column: i))
            }
        }
        return nil
    }
    
    static func getOneOptionLeftHint(for line: [CellValue?]) -> Hint? {
        
        guard
            line.count(where: { $0 != nil}) == 5,
            let targetIndex = line.firstIndex(of: nil)
        else {
            return nil
        }
        
        let zerosCount = line.count { $0 == .zero }
        let onesCount = line.count { $0 == .one }
        let relatedCells = (0..<line.count).map { CellPosition(row: 0, column: $0) }.filter { $0.column != targetIndex }
        let correctValue: CellValue = zerosCount > onesCount ? .one : .zero
        
        return Hint(type: .oneOptionLeft(lineName: "", value: correctValue),
                    targetCell: .init(row: 0, column: targetIndex),
                    relatedCells: relatedCells)
    }
    
    static func getSignHint(for line: [CellValue?], with conditions: [GameCellCondition]) -> Hint? {
        for condition in conditions {
            let first = line[condition.cellA.column]
            let second = line[condition.cellB.column]
            
            // TODO: these 2 ifs could be covered with some logical operator? XOR?
            if first == nil && second == nil {
                return nil
            }
            
            if first != nil && second != nil {
                // don't care about sing violation
                // it should be covered with incorrectCell hint
                return nil
            }
            
            if let first {
                let correctValue = first.signed(condition.condition)
                return Hint(type: .sign(sign: condition.condition.symbol,
                                        value: correctValue),
                            targetCell: condition.cellB,
                            relatedCells: [condition.cellA])
            }
            
            if let second {
                let correctValue = second.signed(condition.condition)
                return Hint(type: .sign(sign: condition.condition.symbol,
                                        value: correctValue),
                            targetCell: condition.cellA,
                            relatedCells: [condition.cellB])
            }
        }
        return nil
    }
}

// MARK: Private hint detection helpers
private extension Game {
    
    private static func getNoMoreThan2Hint(of value: CellValue, for line: [CellValue?]) -> Hint? {
        // cell conditions is not important!
        // it runs after incorrectCell check - there is no mistake
        // if the 2-length sequence of one value and around it not nils - go to another value (another sequence of the same value is a mistake, but we have no mistake on this step)
        let oppositeValue: CellValue = (value == .one) ? .zero : .one
        if let range = line.firstRange(of: [value, value]) {
            let startIndex = range.startIndex
            let endIndex = range.endIndex - 1
            if startIndex > 0 {
                if line[range.lowerBound - 1] == nil {
                    return Hint(type: .noMoreThan2(value: oppositeValue),
                                targetCell: .init(row: 0, column: startIndex - 1),
                                relatedCells: [.init(row: 0, column: startIndex),
                                               .init(row: 0, column: endIndex)])
                }
            }
            
            if endIndex < line.count - 1 {
                if line[endIndex + 1] == nil {
                    return Hint(type: .noMoreThan2(value: oppositeValue),
                                targetCell: .init(row: 0, column: endIndex + 1),
                                relatedCells: [.init(row: 0, column: startIndex),
                                               .init(row: 0, column: endIndex)])
                }
            }
        }
        return nil
    }
}
