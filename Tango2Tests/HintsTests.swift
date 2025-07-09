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
    
    // Tests for NoMoreThan2 rule
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
                                  relatedCell: [.init(row: 0, column: 0),
                                                .init(row: 0, column: 1)])
        let result = Game.getNoMoreThan2Hint(for: array, with: [])
        #expect(result == expectedResult)
    }
    
    @Test func getNoMoreThan2HintReturnsHintForN00NNNN() async throws {
        let array: [CellValue?] = [.zero, .zero, nil, nil, nil, nil]
        let expectedResult = Hint(type: .noMoreThan2(value: .one),
                                  targetCell: .init(row: 0, column: 0),
                                  relatedCell: [.init(row: 0, column: 1),
                                                .init(row: 0, column: 2)])
        let result = Game.getNoMoreThan2Hint(for: array, with: [])
        #expect(result == expectedResult)
    }
    
//    @Test func getNoMoreThan2HintReturnsHintFor2Zeros() async throws {
//        let array: [CellValue?] = [.zero, .zero, nil, nil, nil, nil]
//        let expectedResult = Hint(type: .noMoreThan2(value: .one),
//                                  targetCell: .init(row: 0, column: 2),
//                                  relatedCell: [.init(row: 0, column: 0),
//                                                .init(row: 0, column: 1)])
//        let result = Game.getNoMoreThan2Hint(for: array, with: [])
//        #expect(result == expectedResult)
//    }
}
