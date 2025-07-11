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
        return nil
    }
    
    func getHint(forColumnWithIndex columnIndex: Int) -> Hint? {
        let column = column(columnIndex).map { $0.value }
        if let hint = Game.getIncorrectCellHint(for: column, with: solvedColumn(columnIndex)) {
            return Hint(type: hint.type,
                        targetCell: .init(row: hint.targetCell.column, column: columnIndex),
                        relatedCells: hint.relatedCells)
        }
        return nil
    }
}

// MARK: Hints detection
extension Game {
    
    static func getNoMoreThan2Hint(for line: [CellValue?], with conditions: [GameCellCondition]) -> Hint? {
        if line.count(where: { $0 == nil }) >= 5 {
            return nil
        }
        else {
            return Hint(type: .noMoreThan2(value: .one),
                        targetCell: .init(row: 0, column: 2),
                        relatedCells: [.init(row: 0, column: 0),
                                      .init(row: 0, column: 1)])
        }
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
}
