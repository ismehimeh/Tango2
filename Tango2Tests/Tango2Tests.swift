//
//  Tango2Tests.swift
//  Tango2Tests
//
//  Created by Sergei Vasilenko on 28.06.2025.
//

import Testing
@testable import Tango2

struct Tango2Tests {

    @Test func emptyRowReturnsNoError() async throws {
        let game = Game(level2)
        #expect(game.getMistakes(forRowWithIndex: 0).isEmpty)
    }
    
    @Test func correctlyFilledRowReturnsNoError() async throws {
        let game = Game(level3)
        #expect(game.getMistakes(forRowWithIndex: 2).isEmpty)
    }
    
    @Test func detectsEqualSignViolation() async throws {
        let game = Game(testLevel1)
        let expectedResult = [Mistake(cells: [.init(row: 1, column: 0),
                                             .init(row: 1, column: 1)],
                                      type: .signViolation(.equal))]
        #expect(game.getMistakes(forRowWithIndex: 1) == expectedResult)
    }
    
    @Test func detectsOppositeSignViolation() async throws {
        let game = Game(testLevel1)
        let expectedResult = [Mistake(cells: [.init(row: 2, column: 0),
                                             .init(row: 2, column: 1)],
                                      type: .signViolation(.opposite))]
        #expect(game.getMistakes(forRowWithIndex: 2) == expectedResult)
    }
}
