//
//  StubData.swift
//  Tango
//
//  Created by Sergei Vasilenko on 10.03.2025.
//

// MARK: - Level 1
let level1 = Level.create(
    title: "1",
    boardDefinition: [
        [nil, nil, .zero, nil, nil, nil],
        [nil, .one, .one, nil, nil, nil],
        [.one, .one, nil, nil, nil, nil],
        [nil, nil, nil, nil, .one, .zero],
        [nil, nil, nil, .one, .zero, nil],
        [nil, nil, nil, .zero, nil, nil]
    ],
    conditions: [
        (.opposite, (0, 4), (0, 5)),
        (.opposite, (0, 5), (1, 5)),
        (.equal, (4, 0), (5, 0)),
        (.equal, (5, 0), (5, 1))
    ]
)

// MARK:  - Level 2
let level2 = Level.create(
    title: "2",
    boardDefinition: [
        [nil, nil, nil, nil, nil, nil],
        [nil, .one, nil, .zero, .one, nil],
        [nil, .zero, nil, nil, nil, nil],
        [nil, nil, nil, nil, .zero, nil],
        [nil, .one, .zero, nil, .zero, nil],
        [nil, nil, nil, nil, nil, nil]
    ],
    conditions: [
        (.equal, (0, 2), (0, 3)),
        (.opposite, (0, 4), (0, 5)),
        (.opposite, (1, 0), (2, 0)),
        (.equal, (3, 5), (4, 5)),
        (.equal, (5, 0), (5, 1)),
        (.opposite, (5, 2), (5, 3))
    ]
)


// MARK: - Level 3
//basically, it is almost solved level 1
let level3 = Level.create(
    title: "3",
    boardDefinition: [
        [.one, nil, .zero, .one, .one, .zero],
        [.zero, .one, .one, .zero, .zero, .one],
        [.one, .one, .zero, .one, .zero, .zero],
        [.one, .zero, .one, .zero, .one, .zero],
        [.zero, .one, .zero, .one, .zero, .one],
        [.zero, .zero, .one, .zero, .one, .one]
    ],
    conditions: [
        (.opposite, (0, 4), (0, 5)),
        (.opposite, (0, 5), (1, 5)),
        (.equal, (4, 0), (5, 0)),
        (.equal, (5, 0), (5, 1))
    ]
)

let mistakesTestLevel = Level.create(
    title: "Mistakes Test",
    boardDefinition: [
        [.zero, .one, nil, nil, nil, nil],
        [.zero, .zero, nil, nil, nil, nil],
        [.zero, .one, nil, nil, .zero, .zero],
        [.zero, .one, .one, nil, nil, nil],
    ],
    conditions: [
        (.equal, (0, 0), (0, 1)),
        (.opposite, (1, 0), (1, 1)),
        (.equal, (2, 0), (2, 1)),
        (.opposite, (2, 4), (2, 5)),
        (.equal, (3, 0), (3, 1)),
        (.opposite, (3, 1), (3, 2))
    ]
)

// Test level specifically for consecutive values rule
let consecutiveValuesTestLevel = Level.create(
    title: "Consecutive Values Test",
    boardDefinition: [
        // Row with two consecutive values (valid)
        [.zero, .zero, nil, nil, nil, nil],
        // Row with three consecutive zeroes (invalid)
        [.zero, .zero, .zero, nil, nil, nil],
        // Row with three consecutive ones (invalid)
        [nil, nil, .one, .one, .one, nil],
        // Row with both sign violation and consecutive values violation
        [.zero, .one, .one, .one, nil, nil]
    ],
    conditions: [
        // This condition will be violated in row 3
        (.equal, (3, 0), (3, 1))
    ]
)
