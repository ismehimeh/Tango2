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
    
    @Test func checkNoMoreThan2ForEmptyRowReturnsNil() async throws {
        let array: [CellValue?] = [nil, nil, nil, nil, nil]
        let expectedResult: (Int, Int)? = nil
        let result = Game.checkNoMoreThan2(of: .one, in: array)
        #expect(result?.0 == expectedResult?.0)
        #expect(result?.1 == expectedResult?.1)
    }
    
    @Test func checkNoMoreThan2ForRowWith2OnesReturnsNil() async throws {
        let array: [CellValue?] = [.one, .one, nil, nil, nil]
        let expectedResult: (Int, Int)? = nil
        let result = Game.checkNoMoreThan2(of: .one, in: array)
        #expect(result?.0 == expectedResult?.0)
        #expect(result?.1 == expectedResult?.1)
    }
    
    @Test func checkNoMoreThan2ForRowWith3OnesReturns02() async throws {
        let array: [CellValue?] = [.one, .one, .one, nil, nil, nil]
        let expectedResult: (Int, Int)? = (0, 2)
        let result = Game.checkNoMoreThan2(of: .one, in: array)
        #expect(result?.0 == expectedResult?.0)
        #expect(result?.1 == expectedResult?.1)
    }
    
    @Test func checkNoMoreThan2ForRowWith4OnesReturns03() async throws {
        let array: [CellValue?] = [.one, .one, .one, .one, nil, nil]
        let expectedResult: (Int, Int)? = (0, 3)
        let result = Game.checkNoMoreThan2(of: .one, in: array)
        #expect(result?.0 == expectedResult?.0)
        #expect(result?.1 == expectedResult?.1)
    }
    
    @Test func checkNoMoreThan2ForRowWith5OnesReturns04() async throws {
        let array: [CellValue?] = [.one, .one, .one, .one, .one, nil]
        let expectedResult: (Int, Int)? = (0, 4)
        let result = Game.checkNoMoreThan2(of: .one, in: array)
        #expect(result?.0 == expectedResult?.0)
        #expect(result?.1 == expectedResult?.1)
    }
    
    @Test func checkNoMoreThan2ForRowWith6OnesReturns05() async throws {
        let array: [CellValue?] = [.one, .one, .one, .one, .one, .one]
        let expectedResult: (Int, Int)? = (0, 5)
        let result = Game.checkNoMoreThan2(of: .one, in: array)
        #expect(result?.0 == expectedResult?.0)
        #expect(result?.1 == expectedResult?.1)
    }
    
    @Test func checkNoMoreThan2ForRowWith5OnesInTheEndReturns15() async throws {
        let array: [CellValue?] = [nil, .one, .one, .one, .one, .one]
        let expectedResult: (Int, Int)? = (1, 5)
        let result = Game.checkNoMoreThan2(of: .one, in: array)
        #expect(result?.0 == expectedResult?.0)
        #expect(result?.1 == expectedResult?.1)
    }
    
    @Test func checkNoMoreThan2ForRowWith4OnesInTheEndReturns25() async throws {
        let array: [CellValue?] = [nil, nil, .one, .one, .one, .one]
        let expectedResult: (Int, Int)? = (2, 5)
        let result = Game.checkNoMoreThan2(of: .one, in: array)
        #expect(result?.0 == expectedResult?.0)
        #expect(result?.1 == expectedResult?.1)
    }
    
    @Test func checkNoMoreThan2ForRowWith3OnesInTheMiddleReturns13() async throws {
        let array: [CellValue?] = [nil, .one, .one, .one, nil, nil]
        let expectedResult: (Int, Int)? = (1, 3)
        let result = Game.checkNoMoreThan2(of: .one, in: array)
        #expect(result?.0 == expectedResult?.0)
        #expect(result?.1 == expectedResult?.1)
    }
    
    @Test func checkNoMoreThan2ForRowWithSpecialCase() async throws {
        let array: [CellValue?] = [nil, .one, .one, nil, nil, .one]
        let expectedResult: (Int, Int)? = nil
        let result = Game.checkNoMoreThan2(of: .one, in: array)
        #expect(result?.0 == expectedResult?.0)
        #expect(result?.1 == expectedResult?.1)
    }
    
    @Test func checkNoMoreThan2ForRowWithSpecialCase1() async throws {
        let array: [CellValue?] = [nil, .one, .one, .zero, .one, .one]
        let expectedResult: (Int, Int)? = nil
        let result = Game.checkNoMoreThan2(of: .one, in: array)
        #expect(result?.0 == expectedResult?.0)
        #expect(result?.1 == expectedResult?.1)
    }
    
    // checkNoMoreThan2 for cells
    @Test func checkNoMoreThan2ForCellsRow() async throws {
        let game = Game(testLevel3)
        let row = game.row(0)
        let result = game.checkNoMoreThan2(cells: row, isRow: true, index: 0)
        let expectedResult = [Mistake(cells: [.init(row: 0, column: 0),
                                              .init(row: 0, column: 1),
                                              .init(row: 0, column: 2)], type: .noMoreThan2)]
        #expect(result == expectedResult)
    }
    
    @Test func checkNoMoreThan2ForCellsColumn() async throws {
        let game = Game(testLevel3)
        let column = game.column(0)
        let result = game.checkNoMoreThan2(cells: column, isRow: false, index: 0)
        let expectedResult = [Mistake(cells: [.init(row: 0, column: 0),
                                              .init(row: 1, column: 0),
                                              .init(row: 2, column: 0)], type: .noMoreThan2)]
        #expect(result == expectedResult)
    }
    
    @Test func checkNoMoreThan2ForCellsColumnSpecialCase() async throws {
        let game = Game(testLevel4)
        let column = game.column(1)
        let result = game.checkNoMoreThan2(cells: column, isRow: false, index: 1)
        let expectedResult = [Mistake]()
        #expect(result == expectedResult)
    }
}
