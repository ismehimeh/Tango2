//
//  Tango2Tests.swift
//  Tango2Tests
//
//  Created by Sergei Vasilenko on 28.06.2025.
//

import Testing
@testable import Tango2

struct Tango2Tests {

    @Test func emptyRowReturnsNoErrorForRow() async throws {
        let game = Game(level2)
        #expect(game.getMistakes(forRowWithIndex: 0).isEmpty)
    }
    
    @Test func correctlyFilledRowReturnsNoErrorForRow() async throws {
        let game = Game(level3)
        #expect(game.getMistakes(forRowWithIndex: 2).isEmpty)
    }
    
    @Test func detectsEqualSignViolationForRow() async throws {
        let game = Game(testLevel1)
        let expectedResult = [Mistake(cells: [.init(row: 1, column: 0),
                                             .init(row: 1, column: 1)],
                                      type: .signViolation(.equal))]
        #expect(game.getMistakes(forRowWithIndex: 1) == expectedResult)
    }
    
    @Test func detectsOppositeSignViolationForRow() async throws {
        let game = Game(testLevel1)
        let expectedResult = [Mistake(cells: [.init(row: 2, column: 0),
                                             .init(row: 2, column: 1)],
                                      type: .signViolation(.opposite))]
        #expect(game.getMistakes(forRowWithIndex: 2) == expectedResult)
    }
    
    @Test func detectsOppositeSignViolationForColumn() async throws {
        let game = Game(testLevel1)
        let expectedResult = [Mistake(cells: [.init(row: 1, column: 0),
                                             .init(row: 2, column: 0)],
                                      type: .signViolation(.opposite))]
        #expect(game.getMistakes(forColumnWithIndex: 0) == expectedResult)
    }
    
    @Test func detectsSameNumberViolationForRow() async throws {
        let game = Game(testLevel2)
        let expectedResult = [Mistake(cells: [.init(row: 0, column: 0),
                                              .init(row: 0, column: 1),
                                              .init(row: 0, column: 2),
                                              .init(row: 0, column: 3),
                                              .init(row: 0, column: 4),
                                              .init(row: 0, column: 5)],
                                      type: .sameNumberValues)]
        #expect(game.getMistakes(forRowWithIndex: 0) == expectedResult)
    }

    @Test func detectsSameNumberViolationForColumn() async throws {
        let game = Game(testLevel2)
        let expectedResult = [Mistake(cells: [.init(row: 0, column: 0),
                                              .init(row: 1, column: 0),
                                              .init(row: 2, column: 0),
                                              .init(row: 3, column: 0),
                                              .init(row: 4, column: 0),
                                              .init(row: 5, column: 0)],
                                      type: .sameNumberValues)]
        #expect(game.getMistakes(forColumnWithIndex: 0) == expectedResult)
    }
}
