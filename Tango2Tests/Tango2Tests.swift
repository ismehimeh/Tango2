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
    
    @Test func equalConditionViolationReturnsSignViolationMistake() async throws {
        let game = Game(mistakesTestLevel)
        let expectedResult: [MistakeType] = [.signViolation(.equal)]
        #expect(game.getMistakes(forRowWithIndex: 0) == expectedResult)
    }
    
    @Test func oppositeConditionViolationReturnsSignViolationMistake() async throws {
        let game = Game(mistakesTestLevel)
        let expectedResult: [MistakeType] = [.signViolation(.opposite)]
        #expect(game.getMistakes(forRowWithIndex: 1) == expectedResult)
    }
    
    @Test func twoConditionViolationsReturnTwoMistakes() async throws {
        let game = Game(mistakesTestLevel)
        let expectedResult: [MistakeType] = [.signViolation(.equal), .signViolation(.opposite)]
        #expect(game.getMistakes(forRowWithIndex: 2) == expectedResult)
    }
    
    @Test func twoConditionViolationsInNearbyCellsReturnTwoMistakes() async throws {
        let game = Game(mistakesTestLevel)
        let expectedResult: [MistakeType] = [.signViolation(.equal), .signViolation(.opposite)]
        #expect(game.getMistakes(forRowWithIndex: 3) == expectedResult)
    }
}
