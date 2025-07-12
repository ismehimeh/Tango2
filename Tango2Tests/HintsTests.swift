//
//  HintsTests.swift
//  Tango2Tests
//
//  Created by Sergei Vasilenko on 7.07.2025.
//

import Testing
@testable import Tango2

struct HintsTests {
    
    // MARK: NoMoreThan2 Hint
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
    
    // - MARK:  incorrectCell hint
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
    
    // MARK: oneOptionLeft Hint
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
    
    @Test func receivedCorrectOneOptionLeftHintFor11N011() async throws {
        let line: [CellValue?] = [.one, .one, nil, .zero, .one, .one]
        let expectedValue: Hint? = Hint(type: .oneOptionLeft(lineName: "", value: .zero),
                                        targetCell: .init(row: 0, column: 2),
                                        relatedCells: [
                                            .init(row: 0, column: 0),
                                            .init(row: 0, column: 1),
                                            .init(row: 0, column: 3),
                                            .init(row: 0, column: 4),
                                            .init(row: 0, column: 5)
                                        ])
        let result = Game.getOneOptionLeftHint(for: line)
        #expect(result == expectedValue)
    }
}
