//
//  Game+Hints.swift
//  Tango2
//
//  Created by Sergei Vasilenko on 10.07.2025.
//

// - MARK: Mistakes

typealias Sign = GameCellCondition.Condition

// TODO: hints are designed specifically for 6x6 levels - should I update them for 4x4?

/// Represents the type of line being processed (row or column)
enum LineType {
    case row(index: Int)
    case column(index: Int)
    
    var index: Int {
        switch self {
        case .row(let index), .column(let index):
            return index
        }
    }
    
    var name: String {
        switch self {
        case .row: return "row"
        case .column: return "column"
        }
    }
}

extension Game {
    
    func getHint() -> Hint? {
        // we assume that game field is N x N
        for i in 0..<level.levelCells.count {
            if let hint = getHint(forRowWithIndex: i) {
                return hint
            }
            if let hint = getHint(forColumnWithIndex: i) {
                return hint
            }
        }
        
        return nil
    }
    
    func getHint(forRowWithIndex rowIndex: Int) -> Hint? {
        return getHint(for: .row(index: rowIndex))
    }
    
    func getHint(forColumnWithIndex columnIndex: Int) -> Hint? {
        return getHint(for: .column(index: columnIndex))
    }
    
    /// Common method to get hints for either rows or columns
    private func getHint(for lineType: LineType) -> Hint? {
        let lineValues: [CellValue?]
        let solvedValues: [CellValue]
        
        // Get the appropriate line values and solved values
        switch lineType {
        case .row(let index):
            lineValues = row(index).map { $0.value }
            solvedValues = solvedRow(index)
        case .column(let index):
            lineValues = column(index).map { $0.value }
            solvedValues = solvedColumn(index)
        }
        
        // 1. Check for incorrect cell hints
        if let hint = Game.getIncorrectCellHint(for: lineValues, with: solvedValues) {
            return transformHint(hint, for: lineType)
        }
        
        // 2. Check for no more than 2 hints
        if let hint = Game.getNoMoreThan2Hint(for: lineValues) {
            return transformHint(hint, for: lineType)
        }
        
        // 3. Check for sign hints
        let conditions = getFilteredConditions(for: lineType)
        if let hint = Game.getSignHint(for: lineValues, with: conditions) {
            return transformHint(hint, for: lineType)
        }
        
        // 4. Check for one option left hints
        if let hint = Game.getOneOptionLeftHint(for: lineValues),
           case let .oneOptionLeft(_, value) = hint.type
        {
            
            return Hint(type: .oneOptionLeft(
                lineName: lineType.name,
                value: value),
                        targetCell: transformCellPosition(hint.targetCell, for: lineType),
                        relatedCells: hint.relatedCells.map { transformCellPosition($0, for: lineType) })
        }
        
        // 5. Check for forced 3 with same number hint
        if let hint = Game.getForcedThreeWithSameNumberHint(for: lineValues),
            case let .forcedThreeWithSameNumber(_, value) = hint.type
        {
            return Hint(type: .forcedThreeWithSameNumber(lineName: lineType.name, value: value),
                        targetCell: transformCellPosition(hint.targetCell, for: lineType),
                        relatedCells: hint.relatedCells.map { transformCellPosition($0, for: lineType) })
        }
        
        // 6. Check for forcedThreeNoMoreThan2Hint
        if let hint = Game.getForcedThreeNoMoreThan2Hint(in: lineValues, with: conditions) {
            return transformHint(hint, for: lineType)
        }
        
        // 6. Check for tripple opposite special case
        // TODO: it should be last!
        if
            let hint = Game.getTripleOppositeHint(in: lineValues, with: conditions),
            case let .tripleOpposite(_, value) = hint.type
        {
            return Hint(type: .tripleOpposite(lineName: lineType.name, value: value),
                        targetCell: transformCellPosition(hint.targetCell, for: lineType),
                        relatedCells: hint.relatedCells.map { transformCellPosition($0, for: lineType) })
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
            let targetIndex = line.firstIndex(of: nil)
        else {
            return nil
        }
        
        let zerosCount = line.count { $0 == .zero }
        let onesCount = line.count { $0 == .one }
        
        guard zerosCount == 3 || onesCount == 3 else { return nil }
        let relatedCells: [CellPosition] = (0..<line.count).compactMap {
            guard line[$0] != nil else { return nil }
            return CellPosition(row: 0, column: $0)
        }
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
                continue
            }
            
            if first != nil && second != nil {
                // don't care about sing violation
                // it should be covered with incorrectCell hint
                continue
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
    
    // MARK: ForcedThreeWithSameNumber
    static func getForcedThreeWithSameNumberHint(for line: [CellValue?]) -> Hint? {
        if let hint = getForcedThreeWithSameNumberHint(of: .zero, in: line) {
            return hint
        }
        
        if let hint = getForcedThreeWithSameNumberHint(of: .one, in: line) {
            return hint
        }
        return nil
    }
    
    private static func getForcedThreeWithSameNumberHint(of value: CellValue,
                                                         in line: [CellValue?]) -> Hint?
    {
        // TODO: Improve relatedCells selection
        
        // This hint suggests that by placing value, we will reach limit of that value
        // and that we will force three of opposite values be placed together
        // it means that if line doesn't have 2 same value - we can skip it
        guard line.count(where: { $0 == value }) == 2 else { return nil }
        
        // okay, not let's just iterate over every index
        // and replace nil with value
        // and check will it lead to placing 3 opposite values in the cells left
        for i in line.indices {
            guard line[i] == nil else { continue }
            var lineCopy = line
            lineCopy[i] = value
            
            // it looks like this situation happens when we have one or zero appearences of opposite value
            // and there are 4 combinations of problematic sequences which are not include value
            // NNN, NN1, N1N, 1NN
            // let's look for them
            let opposite = value.opposite
            let problematicSequences: [[CellValue?]] = [
                [nil, nil, nil],
                [nil, nil, opposite],
                [nil, opposite, nil],
                [opposite, nil, nil],
            ]
            
            let rangesOfProblematicSequence = problematicSequences.compactMap { sequence in
                lineCopy.firstRange(of: sequence)
            }
            
            if rangesOfProblematicSequence.isEmpty {
                // no problematic possible sequences found
                continue
            }
            
            let valuesIndices: [Int] = line.enumerated().compactMap { $0.element != nil ? $0.offset : nil }
            return Hint(type: .forcedThreeWithSameNumber(lineName: "", value: value.opposite),
                        targetCell: .init(row: 0, column: i),
                        relatedCells: valuesIndices.map { .init(row: 0, column: $0) })
        }
        
        return nil
    }
    
    static func getTripleOppositeHint(in line: [CellValue?],
                                      with conditions: [GameCellCondition]) -> Hint?
    {
        let nilSequence: [CellValue?] = [nil, nil, nil]
        guard let nilSequenceRange = line.firstRange(of: nilSequence) else { return nil }
        
        let notNilSequences: [[CellValue?]] = [
            [.zero, .one, .zero],
            [.one, .zero, .one]
        ]
        
        let containsFirstSequence = line.contains(notNilSequences[0])
        guard containsFirstSequence ||  line.contains(notNilSequences[1]) else { return nil }
        
        let conditions1: [GameCellCondition] = [.init(condition: .opposite,
                                                     cellA: .init(row: 0, column: 0),
                                                     cellB: .init(row: 0, column: 1)),
                                               .init(condition: .opposite,
                                                     cellA: .init(row: 0, column: 1),
                                                     cellB: .init(row: 0, column: 2)),
        ]
        
        let conditions2: [GameCellCondition] = [.init(condition: .opposite,
                                                     cellA: .init(row: 0, column: 3),
                                                     cellB: .init(row: 0, column: 4)),
                                               .init(condition: .opposite,
                                                     cellA: .init(row: 0, column: 4),
                                                     cellB: .init(row: 0, column: 5))
        ]
        guard conditions.contains(conditions1) || conditions.contains(conditions2) else { return nil }
        
        let value: CellValue = containsFirstSequence ? .one : .zero
        
        let targetCell: CellPosition
        if nilSequenceRange.startIndex == 0 {
            targetCell = .init(row: 0, column: 2)
        }
        else {
            targetCell = .init(row: 0, column: 3)
        }
        
        let relatedCells = (0..<line.count)
            .filter { !nilSequenceRange.contains($0) }
            .map { CellPosition(row: 0, column: $0) }
        
        return Hint(type: .tripleOpposite(lineName: "", value: value), targetCell: targetCell, relatedCells: relatedCells)
    }
    
    // MARK: ForcedThreeNoMoreThan2
    static func getForcedThreeNoMoreThan2Hint(in line: [CellValue?],
                                              with conditions: [GameCellCondition]) -> Hint?
    {
        // looks like this hint is all about equal sign and 2 empty cell around
        
        let equalConditionWithNils = conditions.first { $0.condition == .equal &&
                                                        line[$0.cellA.column] == nil &&
                                                        line[$0.cellB.column] == nil }
        
        guard let equal = equalConditionWithNils else { return nil }
        
        if
            equal.cellA.column > 0,
            let value = line[equal.cellA.column - 1]
        {
            return Hint(type: .forcedThreeNoMoreThan2(value: value.opposite, sign: Sign.equal.symbol),
                        targetCell: equal.cellA,
                        relatedCells: [equal.cellB,
                                       .init(row: 0, column: equal.cellA.column - 1)])
        }
        
        if
            equal.cellB.column < line.count - 1,
            let value = line[equal.cellB.column + 1]
        {
            return Hint(type: .forcedThreeNoMoreThan2(value: value.opposite, sign: Sign.equal.symbol),
                        targetCell: equal.cellB,
                        relatedCells: [equal.cellA,
                                       .init(row: 0, column: equal.cellB.column + 1)])
        }
        
        return nil
    }
}

private extension Game {
    
    // MARK: No more than 2
    private static func getNoMoreThan2Hint(of value: CellValue, for line: [CellValue?]) -> Hint? {
        // cell conditions is not important!
        // it runs after incorrectCell check - there is no mistake
        // if the 2-length sequence of one value and around it not nils - go to another value (another sequence of the same value is a mistake, but we have no mistake on this step)
        
        // looking for 2 symbols after each other
        if let range = line.firstRange(of: [value, value]) {
            let startIndex = range.startIndex
            let endIndex = range.endIndex - 1
            if startIndex > 0 {
                if line[range.lowerBound - 1] == nil {
                    return Hint(type: .noMoreThan2(value: value.opposite),
                                targetCell: .init(row: 0, column: startIndex - 1),
                                relatedCells: [.init(row: 0, column: startIndex),
                                               .init(row: 0, column: endIndex)])
                }
            }
            
            if endIndex < line.count - 1 {
                if line[endIndex + 1] == nil {
                    return Hint(type: .noMoreThan2(value: value.opposite),
                                targetCell: .init(row: 0, column: endIndex + 1),
                                relatedCells: [.init(row: 0, column: startIndex),
                                               .init(row: 0, column: endIndex)])
                }
            }
        }
        
        // looking for symbol-nil-symbol
        if let range = line.firstRange(of: [value, nil, value]) {
            let startIndex = range.startIndex
            let endIndex = range.endIndex - 1
            return Hint(type: .noMoreThan2(value: value.opposite),
                        targetCell: .init(row: 0, column: startIndex + 1),
                        relatedCells: [.init(row: 0, column: startIndex),
                                       .init(row: 0, column: endIndex)])
        }
        return nil
    }
}

// MARK: Private helpers
private extension Game {
    
    /// Gets the filtered conditions relevant for the given line type
    private func getFilteredConditions(for lineType: LineType) -> [GameCellCondition] {
        switch lineType {
        case .row(let index):
            return gameConditions.filter {
                $0.cellA.column != $0.cellB.column && $0.cellA.row == index
            }.map {
                GameCellCondition(
                    condition: $0.condition,
                    cellA: .init(row: 0, column: $0.cellA.column),
                    cellB: .init(row: 0, column: $0.cellB.column))
            }
            
        case .column(let index):
            return gameConditions.filter {
                $0.cellA.row != $0.cellB.row && $0.cellA.column == index
            }.map {
                GameCellCondition(
                    condition: $0.condition,
                    cellA: .init(row: 0, column: $0.cellA.row),
                    cellB: .init(row: 0, column: $0.cellB.row))
            }
        }
    }
    
    /// Transforms a cell position from line coordinates to game board coordinates
    private func transformCellPosition(_ position: CellPosition, for lineType: LineType) -> CellPosition {
        switch lineType {
        case .row(let rowIndex):
            return .init(row: rowIndex, column: position.column)
        case .column(let columnIndex):
            return .init(row: position.column, column: columnIndex)
        }
    }
    
    /// Transforms a hint from line coordinates to game board coordinates
    private func transformHint(_ hint: Hint, for lineType: LineType) -> Hint {
        return Hint(
            type: hint.type,
            targetCell: transformCellPosition(hint.targetCell, for: lineType),
            relatedCells: hint.relatedCells.map { transformCellPosition($0, for: lineType) }
        )
    }
}
