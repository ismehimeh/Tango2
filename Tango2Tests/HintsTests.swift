//
//  HintsTests.swift
//  Tango2Tests
//
//  Created by Sergei Vasilenko on 7.07.2025.
//

import Testing
@testable import Tango2

typealias Sign = GameCellCondition.Condition

struct HintsTests { }

// MARK: NoMoreThan2 Hint
extension HintsTests {
    @Test func getNoMoreThan2HintReturnNilForNilLine() async throws {
        let array: [CellValue?] = [nil, nil, nil, nil, nil, nil]
        let expectedResult: Hint? = nil
        let result = Game.getNoMoreThan2Hint(for: array)
        #expect(result == expectedResult)
    }
    
    @Test func getNoMoreThan2HintReturnNilForASingleZero() async throws {
        let array: [CellValue?] = [.zero, nil, nil, nil, nil, nil]
        let expectedResult: Hint? = nil
        let result = Game.getNoMoreThan2Hint(for: array)
        #expect(result == expectedResult)
    }

    @Test func getNoMoreThan2HintReturnsHintFor2Zeros() async throws {
        let array: [CellValue?] = [.zero, .zero, nil, nil, nil, nil]
        let expectedResult = Hint(type: .noMoreThan2(value: .one),
                                  targetCell: .init(row: 0, column: 2),
                                  relatedCells: [.init(row: 0, column: 0),
                                                .init(row: 0, column: 1)])
        let result = Game.getNoMoreThan2Hint(for: array)
        #expect(result == expectedResult)
    }
    
    @Test func getNoMoreThan2HintReturnsHintForN00NNN() async throws {
        let array: [CellValue?] = [nil, .zero, .zero, nil, nil, nil]
        let expectedResult = Hint(type: .noMoreThan2(value: .one),
                                  targetCell: .init(row: 0, column: 0),
                                  relatedCells: [.init(row: 0, column: 1),
                                                .init(row: 0, column: 2)])
        let result = Game.getNoMoreThan2Hint(for: array)
        #expect(result == expectedResult)
    }
    
    @Test func getNoMoreThan2HintReturnsHintFor100NNN() async throws {
        let array: [CellValue?] = [.one, .zero, .zero, nil, nil, nil]
        let expectedResult = Hint(type: .noMoreThan2(value: .one),
                                  targetCell: .init(row: 0, column: 3),
                                  relatedCells: [.init(row: 0, column: 1),
                                                .init(row: 0, column: 2)])
        let result = Game.getNoMoreThan2Hint(for: array)
        #expect(result == expectedResult)
    }
    
    @Test func getNoMoreThan2HintReturnsHintFor1001NN() async throws {
        let array: [CellValue?] = [.one, .zero, .zero, .one, nil, nil]
        let expectedResult: Hint? = nil
        let result = Game.getNoMoreThan2Hint(for: array)
        #expect(result == expectedResult)
    }
    
    @Test func getNoMoreThan2HintReturnsHintForNNNN11() async throws {
        let array: [CellValue?] = [nil, nil, nil, nil, .one, .one]
        let expectedResult = Hint(type: .noMoreThan2(value: .zero),
                                  targetCell: .init(row: 0, column: 3),
                                  relatedCells: [.init(row: 0, column: 4),
                                                .init(row: 0, column: 5)])
        let result = Game.getNoMoreThan2Hint(for: array)
        #expect(result == expectedResult)
    }
    
    @Test func getNoMoreThan2HintReturnsHintForNNN11N() async throws {
        let array: [CellValue?] = [nil, nil, nil, .one, .one, nil]
        let expectedResult = Hint(type: .noMoreThan2(value: .zero),
                                  targetCell: .init(row: 0, column: 2),
                                  relatedCells: [.init(row: 0, column: 3),
                                                .init(row: 0, column: 4)])
        let result = Game.getNoMoreThan2Hint(for: array)
        #expect(result == expectedResult)
    }
    
    @Test func getNoMoreThan2HintReturnsHintForNN011N() async throws {
        let array: [CellValue?] = [nil, nil, .zero, .one, .one, nil]
        let expectedResult = Hint(type: .noMoreThan2(value: .zero),
                                  targetCell: .init(row: 0, column: 5),
                                  relatedCells: [.init(row: 0, column: 3),
                                                .init(row: 0, column: 4)])
        let result = Game.getNoMoreThan2Hint(for: array)
        #expect(result == expectedResult)
    }
    
    @Test func getNoMoreThan2HintReturnsHintForNN0110() async throws {
        let array: [CellValue?] = [nil, nil, .zero, .one, .one, .zero]
        let expectedResult: Hint? = nil
        let result = Game.getNoMoreThan2Hint(for: array)
        #expect(result == expectedResult)
    }
    
    @Test func getNoMoreThan2HintFor1N1NNN() async throws {
        let array: [CellValue?] = [.one, nil, .one, nil, nil, nil]
        let expectedResult: Hint? = Hint(type: .noMoreThan2(value: .zero),
                                         targetCell: .init(row: 0, column: 1),
                                         relatedCells: [.init(row: 0, column: 0),
                                            .init(row: 0, column: 2)])
        let result = Game.getNoMoreThan2Hint(for: array)
        #expect(result == expectedResult)
    }
}

// - MARK:  incorrectCell hint
extension HintsTests {
    @Test func noHintForEmptyLine() async throws {
        let line: [CellValue?] = [nil, nil, nil, nil, nil, nil]
        let correctLine: [CellValue] = [.zero, .one, .zero, .one, .zero, .one]
        let result = Game.getIncorrectCellHint(for: line, with: correctLine)
        #expect(result == nil)
    }
    
    @Test func noHintForCorrectFirstValue() async throws {
        let line: [CellValue?] = [.zero, nil, nil, nil, nil, nil]
        let correctLine: [CellValue] = [.zero, .one, .zero, .one, .zero, .one]
        let result = Game.getIncorrectCellHint(for: line, with: correctLine)
        #expect(result == nil)
    }
    
    @Test func receivedHintForIncorrectFirstValue() async throws {
        let line: [CellValue?] = [.one, nil, nil, nil, nil, nil]
        let correctLine: [CellValue] = [.zero, .one, .zero, .one, .zero, .one]
        let result = Game.getIncorrectCellHint(for: line, with: correctLine)
        let expectedValue = Hint(type: .incorrectCell(value: .zero),
                                 targetCell: .init(row: 0, column: 0))
        #expect(result == expectedValue)
    }
    
    @Test func receivedHintForIncorrectSecondValue() async throws {
        let line: [CellValue?] = [nil, .zero, nil, nil, nil, nil]
        let correctLine: [CellValue] = [.zero, .one, .zero, .one, .zero, .one]
        let result = Game.getIncorrectCellHint(for: line, with: correctLine)
        let expectedValue = Hint(type: .incorrectCell(value: .one),
                                 targetCell: .init(row: 0, column: 1))
        #expect(result == expectedValue)
    }
    
    @Test func receivedCorrectHintFor2IncorrectValues() async throws {
        let line: [CellValue?] = [.one, .zero, nil, nil, nil, nil]
        let correctLine: [CellValue] = [.zero, .one, .zero, .one, .zero, .one]
        let result = Game.getIncorrectCellHint(for: line, with: correctLine)
        let expectedValue = Hint(type: .incorrectCell(value: .zero),
                                 targetCell: .init(row: 0, column: 0))
        #expect(result == expectedValue)
    }
}

// MARK: oneOptionLeft Hint
extension HintsTests {
    @Test func noOneOptionLeftHintForEmptyLine() async throws {
        let line: [CellValue?] = [nil, nil, nil, nil, nil, nil]
        let expectedValue: Hint? = nil
        let result = Game.getOneOptionLeftHint(for: line)
        #expect(result == expectedValue)
    }
    
    @Test func noOneOptionLeftHintFor0011NN() async throws {
        let line: [CellValue?] = [.zero, .zero, .one, .one, nil, nil]
        let expectedValue: Hint? = nil
        let result = Game.getOneOptionLeftHint(for: line)
        #expect(result == expectedValue)
    }
    
    @Test func noOneOptionLeftHintFor0110NN() async throws {
        let line: [CellValue?] = [.zero, .one, .one, .zero, nil, nil]
        let expectedValue: Hint? = nil
        let result = Game.getOneOptionLeftHint(for: line)
        #expect(result == expectedValue)
    }
    
    @Test func receivedCorrectOneOptionLeftHintFor00110N() async throws {
        let line: [CellValue?] = [.zero, .zero, .one, .one, .zero, nil]
        let expectedValue: Hint? = Hint(type: .oneOptionLeft(lineName: "", value: .one),
                                        targetCell: .init(row: 0, column: 5),
                                        relatedCells: [
                                            .init(row: 0, column: 0),
                                            .init(row: 0, column: 1),
                                            .init(row: 0, column: 2),
                                            .init(row: 0, column: 3),
                                            .init(row: 0, column: 4)
                                        ])
        let result = Game.getOneOptionLeftHint(for: line)
        #expect(result == expectedValue)
    }
    
    @Test func receivedCorrectOneOptionLeftHintFor11001N() async throws {
        let line: [CellValue?] = [.one, .one, .zero, .zero, .one, nil]
        let expectedValue: Hint? = Hint(type: .oneOptionLeft(lineName: "", value: .zero),
                                        targetCell: .init(row: 0, column: 5),
                                        relatedCells: [
                                            .init(row: 0, column: 0),
                                            .init(row: 0, column: 1),
                                            .init(row: 0, column: 2),
                                            .init(row: 0, column: 3),
                                            .init(row: 0, column: 4)
                                        ])
        let result = Game.getOneOptionLeftHint(for: line)
        #expect(result == expectedValue)
    }
    
    @Test func receivedCorrectOneOptionLeftHintFor010NN0() async throws {
        let line: [CellValue?] = [.zero, .one, .zero, nil, nil, .zero]
        let expectedValue: Hint? = Hint(type: .oneOptionLeft(lineName: "", value: .one),
                                        targetCell: .init(row: 0, column: 3),
                                        relatedCells: [.init(row: 0, column: 0),
                                                       .init(row: 0, column: 1),
                                                       .init(row: 0, column: 2),
                                                       .init(row: 0, column: 5)])
        let result = Game.getOneOptionLeftHint(for: line)
        #expect(result == expectedValue)
    }
}

// - MARK: sign hint
extension HintsTests {
    
    @Test func noHintForLineWithNoSign() {
        let line: [CellValue?] = [nil, nil, nil, nil, nil, nil]
        let conditions: [GameCellCondition] = [.init(condition: .equal,
                                                     cellA: .init(row: 0, column: 0),
                                                     cellB: .init(row: 0, column: 1))]
        let expectedValue: Hint? = nil
        let result = Game.getSignHint(for: line, with: conditions)
        #expect(result == expectedValue)
    }
    
    @Test func noHintForEmptyLineWithSign() {
        let line: [CellValue?] = [nil, nil, nil, nil, nil, nil]
        let conditions: [GameCellCondition] = []
        let expectedValue: Hint? = nil
        let result = Game.getSignHint(for: line, with: conditions)
        #expect(result == expectedValue)
    }
    
    @Test func gotSignHintFor0AndOEqual() {
        let line: [CellValue?] = [.zero, nil, nil, nil, nil, nil]
        let conditions: [GameCellCondition] = [.init(condition: .equal,
                                                     cellA: .init(row: 0, column: 0),
                                                     cellB: .init(row: 0, column: 1))]
        let expectedValue: Hint? = .init(type: .sign(sign: Sign.equal.symbol, value: .zero),
                                         targetCell: .init(row: 0, column: 1),
                                         relatedCells: [.init(row: 0, column: 0)])
        let result = Game.getSignHint(for: line, with: conditions)
        #expect(result == expectedValue)
    }
    
    @Test func gotSignHintFor0AndEqualReversed() {
        let line: [CellValue?] = [nil, .zero, nil, nil, nil, nil]
        let conditions: [GameCellCondition] = [.init(condition: .equal,
                                                     cellA: .init(row: 0, column: 0),
                                                     cellB: .init(row: 0, column: 1))]
        let expectedValue: Hint? = .init(type: .sign(sign: Sign.equal.symbol, value: .zero),
                                         targetCell: .init(row: 0, column: 0),
                                         relatedCells: [.init(row: 0, column: 1)])
        let result = Game.getSignHint(for: line, with: conditions)
        #expect(result == expectedValue)
    }
    
    @Test func gotSignHintFor1AndOEqual() {
        let line: [CellValue?] = [.one, nil, nil, nil, nil, nil]
        let conditions: [GameCellCondition] = [.init(condition: .equal,
                                                     cellA: .init(row: 0, column: 0),
                                                     cellB: .init(row: 0, column: 1))]
        let expectedValue: Hint? = .init(type: .sign(sign: Sign.equal.symbol, value: .one),
                                         targetCell: .init(row: 0, column: 1),
                                         relatedCells: [.init(row: 0, column: 0)])
        let result = Game.getSignHint(for: line, with: conditions)
        #expect(result == expectedValue)
    }
    
    @Test func gotSignHintFor1AndEqualReversed() {
        let line: [CellValue?] = [nil, .one, nil, nil, nil, nil]
        let conditions: [GameCellCondition] = [.init(condition: .equal,
                                                     cellA: .init(row: 0, column: 0),
                                                     cellB: .init(row: 0, column: 1))]
        let expectedValue: Hint? = .init(type: .sign(sign: Sign.equal.symbol, value: .one),
                                         targetCell: .init(row: 0, column: 0),
                                         relatedCells: [.init(row: 0, column: 1)])
        let result = Game.getSignHint(for: line, with: conditions)
        #expect(result == expectedValue)
    }
    
    @Test func gotSignHintFor0And2Conditions() {
        let line: [CellValue?] = [nil, nil, nil, nil, .zero, nil]
        let conditions: [GameCellCondition] = [.init(condition: .equal,
                                                     cellA: .init(row: 0, column: 2),
                                                     cellB: .init(row: 0, column: 3)),
                                               .init(condition: .opposite,
                                                     cellA: .init(row: 0, column: 4),
                                                     cellB: .init(row: 0, column: 5))]
        let expectedValue: Hint? = .init(type: .sign(sign: Sign.opposite.symbol, value: .one),
                                         targetCell: .init(row: 0, column: 5),
                                         relatedCells: [.init(row: 0, column: 4)])
        let result = Game.getSignHint(for: line, with: conditions)
        #expect(result == expectedValue)
    }
    
    // - MARK: forcedThreeWithSameNumber
    @Test func gotHintForForcedThreeWithSameNumberNNN100() {
        let line: [CellValue?] = [nil, nil, nil, .one, .zero, .zero]
        let expectedValue: Hint? = .init(type: .forcedThreeWithSameNumber(lineName: "",
                                                                          value: .one),
                                         targetCell: .init(row: 0, column: 0),
                                         relatedCells: [.init(row: 0, column: 3),
                                                        .init(row: 0, column: 4),
                                                        .init(row: 0, column: 5)])
        let result = Game.getForcedThreeWithSameNumberHint(for: line)
        #expect(result == expectedValue)
    }
    
    @Test func gotHintForForcedThreeWithSameNumber01NNN0() {
        let line: [CellValue?] = [.zero, .one, nil, nil, nil, .zero]
        let expectedValue: Hint? = .init(type: .forcedThreeWithSameNumber(lineName: "",
                                                                          value: .one),
                                         targetCell: .init(row: 0, column: 4),
                                         relatedCells: [.init(row: 0, column: 0),
                                                        .init(row: 0, column: 1),
                                                        .init(row: 0, column: 5)])
        let result = Game.getForcedThreeWithSameNumberHint(for: line)
        #expect(result == expectedValue)
    }
    
    @Test func gotHintForForcedThreeWithSameNumber0NNNN0() {
        let line: [CellValue?] = [.zero, nil, nil, nil, nil, .zero]
        let expectedValue: Hint? = .init(type: .forcedThreeWithSameNumber(lineName: "",
                                                                          value: .one),
                                         targetCell: .init(row: 0, column: 1),
                                         relatedCells: [.init(row: 0, column: 0),
                                                        .init(row: 0, column: 5)])
        let result = Game.getForcedThreeWithSameNumberHint(for: line)
        #expect(result == expectedValue)
    }
    
    @Test func gotHintForForcedThreeWithSameNumber001NNN() {
        let line: [CellValue?] = [.zero, .zero, .one, nil, nil, nil]
        let expectedValue: Hint? = .init(type: .forcedThreeWithSameNumber(lineName: "",
                                                                          value: .one),
                                         targetCell: .init(row: 0, column: 5),
                                         relatedCells: [.init(row: 0, column: 0),
                                                        .init(row: 0, column: 1),
                                                        .init(row: 0, column: 2)])
        let result = Game.getForcedThreeWithSameNumberHint(for: line)
        #expect(result == expectedValue)
    }
}

// MARK: - Tripple Opposite tests
extension HintsTests {
    
    @Test func gotHintForTrippleOpposite() {
        let line1: [CellValue?] = [nil, nil, nil, .zero, .one, .zero]
        let line2: [CellValue?] = [nil, nil, nil, .one, .zero, .one]
        
        let conditions1: [GameCellCondition] = [.init(condition: .opposite,
                                                     cellA: .init(row: 0, column: 0),
                                                     cellB: .init(row: 0, column: 1)),
                                               .init(condition: .opposite,
                                                     cellA: .init(row: 0, column: 1),
                                                     cellB: .init(row: 0, column: 2))]
        
        let expectedValue1: Hint? = .init(type: .tripleOpposite(lineName: "",
                                                                value: .one),
                                         targetCell: .init(row: 0, column: 2),
                                         relatedCells: [.init(row: 0, column: 3),
                                                        .init(row: 0, column: 4),
                                                        .init(row: 0, column: 5)])
        let result1 = Game.getTripleOppositeHint(in: line1, with: conditions1)
        #expect(result1 == expectedValue1)
        
        let expectedValue2: Hint? = .init(type: .tripleOpposite(lineName: "",
                                                                value: .zero),
                                         targetCell: .init(row: 0, column: 2),
                                         relatedCells: [.init(row: 0, column: 3),
                                                        .init(row: 0, column: 4),
                                                        .init(row: 0, column: 5)])
        let result2 = Game.getTripleOppositeHint(in: line2, with: conditions1)
        #expect(result2 == expectedValue2)
        
        let line3: [CellValue?] = [.zero, .one, .zero, nil, nil, nil]
        let line4: [CellValue?] = [.one, .zero, .one, nil, nil, nil]
        
        let conditions2: [GameCellCondition] = [.init(condition: .opposite,
                                                     cellA: .init(row: 0, column: 3),
                                                     cellB: .init(row: 0, column: 4)),
                                               .init(condition: .opposite,
                                                     cellA: .init(row: 0, column: 4),
                                                     cellB: .init(row: 0, column: 5))
        ]
        
        let expectedValue3: Hint? = .init(type: .tripleOpposite(lineName: "",
                                                                value: .one),
                                         targetCell: .init(row: 0, column: 3),
                                         relatedCells: [.init(row: 0, column: 0),
                                                        .init(row: 0, column: 1),
                                                        .init(row: 0, column: 2)])
        let result3 = Game.getTripleOppositeHint(in: line3, with: conditions2)
        #expect(result3 == expectedValue3)
        
        let expectedValue4: Hint? = .init(type: .tripleOpposite(lineName: "",
                                                                value: .zero),
                                         targetCell: .init(row: 0, column: 3),
                                         relatedCells: [.init(row: 0, column: 0),
                                                        .init(row: 0, column: 1),
                                                        .init(row: 0, column: 2)])
        let result4 = Game.getTripleOppositeHint(in: line4, with: conditions2)
        #expect(result4 == expectedValue4)
    }
}

// MARK: forcedThreeNoMoreThan2 
extension HintsTests {
    // NNN=N0x1
    @Test func getForcedThreeNoMoreThan2HintForNNNEqualsN0x1() async throws {
        let line: [CellValue?] = [nil, nil, nil, nil, .zero, .one]
        let conditions: [GameCellCondition] = [.init(condition: .equal,
                                                    cellA: .init(row: 0, column: 2),
                                                    cellB: .init(row: 0, column: 3)),
                                               .init(condition: .opposite,
                                                     cellA: .init(row: 0, column: 4),
                                                     cellB: .init(row: 0, column: 5))]
        
        let expectedResult = Hint(type: .forcedThreeNoMoreThan2(value: .one, sign: Sign.equal.symbol),
                                  targetCell: .init(row: 0, column: 3),
                                  relatedCells: [.init(row: 0, column: 2),
                                                 .init(row: 0, column: 3),
                                                 .init(row: 0, column: 4)])
        
        let result = Game.getForcedThreeNoMoreThan2Hint(in: line, with: conditions)
        #expect(result == expectedResult)
    }
    
    // N=N1x01N
    @Test func getForcedThreeNoMoreThan2HintForNEqualsN1x01N() async throws {
        let line: [CellValue?] = [nil, nil, .one, .zero, .one, nil]
        let conditions: [GameCellCondition] = [.init(condition: .equal,
                                                    cellA: .init(row: 0, column: 0),
                                                    cellB: .init(row: 0, column: 1)),
                                               .init(condition: .opposite,
                                                     cellA: .init(row: 0, column: 2),
                                                     cellB: .init(row: 0, column: 3))]
        
        let expectedResult = Hint(type: .forcedThreeNoMoreThan2(value: .zero, sign: Sign.equal.symbol),
                                  targetCell: .init(row: 0, column: 1),
                                  relatedCells: [.init(row: 0, column: 0),
                                                .init(row: 0, column: 2)])
        
        let result = Game.getForcedThreeNoMoreThan2Hint(in: line, with: conditions)
        #expect(result == expectedResult)
    }
    
    // NN=N1NN
    @Test func getForcedThreeNoMoreThan2HintForNNEqualsN1NN() async throws {
        let line: [CellValue?] = [nil, nil, nil, .one, nil, nil]
        let conditions: [GameCellCondition] = [.init(condition: .equal,
                                                    cellA: .init(row: 0, column: 1),
                                                    cellB: .init(row: 0, column: 2))]
        
        let expectedResult = Hint(type: .forcedThreeNoMoreThan2(value: .zero, sign: Sign.equal.symbol),
                                  targetCell: .init(row: 0, column: 0),
                                  relatedCells: [.init(row: 0, column: 2),
                                                .init(row: 0, column: 1),
                                                .init(row: 0, column: 3)])
        
        let result = Game.getForcedThreeNoMoreThan2Hint(in: line, with: conditions)
        #expect(result == expectedResult)
    }
    
    // NNN=N10
    @Test func getForcedThreeNoMoreThan2HintForNNNEqualsN10() async throws {
        let line: [CellValue?] = [nil, nil, nil, nil, .one, .zero]
        let conditions: [GameCellCondition] = [.init(condition: .equal,
                                                    cellA: .init(row: 0, column: 2),
                                                    cellB: .init(row: 0, column: 3))]
        
        let expectedResult = Hint(type: .forcedThreeNoMoreThan2(value: .zero, sign: Sign.equal.symbol),
                                  targetCell: .init(row: 0, column: 3),
                                  relatedCells: [.init(row: 0, column: 2),
                                                .init(row: 0, column: 4)])
        
        let result = Game.getForcedThreeNoMoreThan2Hint(in: line, with: conditions)
        #expect(result == expectedResult)
    }
}
