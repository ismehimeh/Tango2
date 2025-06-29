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
    
    // MARK: - No More Than 2 Consecutive Values Tests
    
    @Test func twoConsecutiveValuesReturnsNoError() async throws {
        let game = Game(consecutiveValuesTestLevel)
        #expect(game.getMistakes(forRowWithIndex: 0).isEmpty)
    }
    
    @Test func threeConsecutiveZeroesReturnsNoMoreThan2Error() async throws {
        let game = Game(consecutiveValuesTestLevel)
        let expectedResult: [MistakeType] = [.noMoreThan2]
        #expect(game.getMistakes(forRowWithIndex: 1) == expectedResult)
    }
    
    @Test func threeConsecutiveOnesReturnsNoMoreThan2Error() async throws {
        let game = Game(consecutiveValuesTestLevel)
        let expectedResult: [MistakeType] = [.noMoreThan2]
        #expect(game.getMistakes(forRowWithIndex: 2) == expectedResult)
    }
    
    @Test func combinedErrorsReturnsAllMistakes() async throws {
        let game = Game(consecutiveValuesTestLevel)
        let expectedResult: [MistakeType] = [.signViolation(.equal), .noMoreThan2]
        #expect(game.getMistakes(forRowWithIndex: 3).contains(.signViolation(.equal)))
        #expect(game.getMistakes(forRowWithIndex: 3).contains(.noMoreThan2))
    }
    
    // MARK: - Same Number Values Tests
    
    @Test func fullyFilledRowWithEqualZeroesAndOnesDoesntReturnSameNumberValuesError() async throws {
        let game = Game(sameNumberValuesTestLevel)
        let expectedResult: [MistakeType] = [.noMoreThan2]
        #expect(game.getMistakes(forRowWithIndex: 0) == expectedResult)
    }
    
    @Test func partiallyFilledImbalancedRowDoesntReturnSameNumberValuesError() async throws {
        let game = Game(sameNumberValuesTestLevel)
        // Row has more zeros than ones but has empty cells, so no error
        let expectedResult: [MistakeType] = [.noMoreThan2]
        #expect(game.getMistakes(forRowWithIndex: 1) == expectedResult)
    }
    
    @Test func anotherPartiallyFilledRowReturnsNoError() async throws {
        let game = Game(sameNumberValuesTestLevel)
        // Another partially filled row, no error expected
        #expect(game.getMistakes(forRowWithIndex: 2).isEmpty)
    }
    
    @Test func fullyFilledImbalancedRowReturnsSameNumberValuesError() async throws {
        let game = Game(sameNumberValuesTestLevel)
        let expectedResult: [MistakeType] = [.noMoreThan2, .sameNumberValues]
        #expect(game.getMistakes(forRowWithIndex: 3) == expectedResult)
    }
    
    @Test func anotherFullyFilledImbalancedRowReturnsSameNumberValuesError() async throws {
        let game = Game(sameNumberValuesTestLevel)
        let expectedResult: [MistakeType] = [.noMoreThan2, .sameNumberValues]
        #expect(game.getMistakes(forRowWithIndex: 4) == expectedResult)
    }
    
    @Test func rowWithMultipleViolationTypesReturnsAllMistakes() async throws {
        let game = Game(sameNumberValuesTestLevel)
        #expect(game.getMistakes(forRowWithIndex: 5).contains(.noMoreThan2))
        #expect(game.getMistakes(forRowWithIndex: 5).contains(.sameNumberValues))
    }
    
    // MARK: - Column Mistake Tests
    
    @Test func columnWithThreeConsecutiveZeroesReturnsNoMoreThan2Error() async throws {
        let game = Game(columnMistakesTestLevel)
        let expectedResult: [MistakeType] = [.noMoreThan2]
        #expect(game.getMistakes(forColumnWithIndex: 0) == expectedResult)
    }
    
    @Test func columnWithThreeConsecutiveOnesReturnsNoMoreThan2Error() async throws {
        let game = Game(columnMistakesTestLevel)
        let expectedResult: [MistakeType] = [.noMoreThan2]
        #expect(game.getMistakes(forColumnWithIndex: 2) == expectedResult)
    }
    
    @Test func columnWithEqualConditionViolationReturnsSignViolationError() async throws {
        let game = Game(columnMistakesTestLevel)
        let expectedResult: [MistakeType] = [.signViolation(.equal)]
        #expect(game.getMistakes(forColumnWithIndex: 1) == expectedResult)
    }
    
    @Test func columnWithOppositeConditionViolationReturnsSignViolationError() async throws {
        let game = Game(columnMistakesTestLevel)
        let expectedResult: [MistakeType] = [.signViolation(.opposite), .noMoreThan2]
        #expect(game.getMistakes(forColumnWithIndex: 4) == expectedResult)
    }
    
    @Test func columnWithUnbalancedValuesReturnsSameNumberValuesError() async throws {
        let game = Game(columnMistakesTestLevel)
        let expectedResult: [MistakeType] = [.noMoreThan2, .sameNumberValues]
        #expect(game.getMistakes(forColumnWithIndex: 5) == expectedResult)
    }
    
    // MARK: - Board-wide Mistake Tests
    
    @Test func getBoardWideMistakesReturnsAllUniqueErrorTypes() async throws {
        let game = Game(columnMistakesTestLevel)
        let mistakes = game.getMistakes()
        
        #expect(mistakes.contains(.noMoreThan2))
        #expect(mistakes.contains(.signViolation(.equal)))
        #expect(mistakes.contains(.signViolation(.opposite)))
        #expect(mistakes.contains(.sameNumberValues))
    }
}
