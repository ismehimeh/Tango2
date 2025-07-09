//
//  HintsTests.swift
//  Tango2Tests
//
//  Created by Sergei Vasilenko on 7.07.2025.
//

import Testing
@testable import Tango2

struct HintsTests {
    
    // Tests for NoMoreThan2 rule
    @Test func getNoMoreThan2HintReturnNilForNilLine() async throws {
        let array: [CellValue?] = [nil, nil, nil, nil, nil, nil]
        let expectedResult: Hint? = nil
        let result = Game.getNoMoreThan2Hint(for: array, with: [])
        #expect(result == expectedResult)
    }
    
    @Test func getNoMoreThan2HintReturnNilForASingleZero() async throws {
        let array: [CellValue?] = [.zero, nil, nil, nil, nil, nil]
        let expectedResult: Hint? = nil
        let result = Game.getNoMoreThan2Hint(for: array, with: [])
        #expect(result == expectedResult)
    }

    @Test func getNoMoreThan2HintReturnsHintFor2Zeros() async throws {
        let array: [CellValue?] = [.zero, .zero, nil, nil, nil, nil]
        let expectedResult = Hint(type: .noMoreThan2(value: .one),
                                  targetCell: .init(row: 0, column: 2),
                                  relatedCells: [.init(row: 0, column: 0),
                                                .init(row: 0, column: 1)])
        let result = Game.getNoMoreThan2Hint(for: array, with: [])
        #expect(result == expectedResult)
    }
    
//    @Test func getNoMoreThan2HintReturnsHintForN00NNNN() async throws {
//        let array: [CellValue?] = [.zero, .zero, nil, nil, nil, nil]
//        let expectedResult = Hint(type: .noMoreThan2(value: .one),
//                                  targetCell: .init(row: 0, column: 0),
//                                  relatedCell: [.init(row: 0, column: 1),
//                                                .init(row: 0, column: 2)])
//        let result = Game.getNoMoreThan2Hint(for: array, with: [])
//        #expect(result == expectedResult)
//    }
    
//    @Test func getNoMoreThan2HintReturnsHintFor2Zeros() async throws {
//        let array: [CellValue?] = [.zero, .zero, nil, nil, nil, nil]
//        let expectedResult = Hint(type: .noMoreThan2(value: .one),
//                                  targetCell: .init(row: 0, column: 2),
//                                  relatedCell: [.init(row: 0, column: 0),
//                                                .init(row: 0, column: 1)])
//        let result = Game.getNoMoreThan2Hint(for: array, with: [])
//        #expect(result == expectedResult)
//    }
    
    // Tests for incorrectCell hint
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
