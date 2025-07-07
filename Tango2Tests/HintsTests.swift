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
    @Test func testNoMoreThan2() async throws {
        let array: [CellValue?] = [.zero, .zero, nil, nil, nil, nil]
        let expectedResult = Hint(type: .noMoreThan2(option: ""),
                                  targetCell: .init(row: 0, column: 2),
                                  relatedCell: [.init(row: 0, column: 0),
                                                .init(row: 0, column: 1)])
    }

}
