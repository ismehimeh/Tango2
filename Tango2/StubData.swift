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
    ],
    solvedCells: [
        [.one, .zero, .zero, .one, .one, .zero],
        [.zero, .one, .one, .zero, .zero, .one],
        [.one, .one, .zero, .one, .zero, .zero],
        [.one, .zero, .one, .zero, .one, .zero],
        [.zero, .one, .zero, .one, .zero, .one],
        [.zero, .zero, .one, .zero, .one, .one],
    ]
)

// Level 1 with mistake
let level1WithMistake = Level.create(
    title: "1",
    boardDefinition: [
        [nil, nil, .zero, nil, nil, nil],
        [nil, .one, .one, nil, nil, nil],
        [.one, .one, .one, nil, nil, nil],
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
    ],
    solvedCells: [
        [.zero, .zero, .one, .one, .zero, .one],
        [.one, .one, .zero, .zero, .one, .zero],
        [.zero, .zero, .one, .zero, .one, .one],
        [.one, .one, .zero, .one, .zero, .zero],
        [.one, .one, .zero, .one, .zero, .zero],
        [.zero, .zero, .one, .zero, .one, .one],
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
    ],
    solvedCells: [
        [.one, .zero, .zero, .one, .one, .zero],
        [.zero, .one, .one, .zero, .zero, .one],
        [.one, .one, .zero, .one, .zero, .zero],
        [.one, .zero, .one, .zero, .one, .zero],
        [.zero, .one, .zero, .one, .zero, .one],
        [.zero, .zero, .one, .zero, .one, .one],
    ])

// Difficulty: HARD
let level4 = Level.create(
    title: "4",
    boardDefinition: [
        [.zero, nil, nil, .zero, nil, nil],
        [nil, nil, nil, nil, nil, nil],
        [.one, nil, nil, .zero, nil, nil],
        [nil, nil, .zero, nil, nil, .zero],
        [nil, nil, nil, nil, nil, nil],
        [nil, nil, .zero, nil, nil, .zero]
    ], conditions: [
        (.equal, (1, 1), (1, 2)),
        (.opposite, (4, 3), (4, 4)),
        (.equal, (0, 5), (1, 5)),
        (.opposite, (4, 0), (5, 0))
    ],
    solvedCells: [
        [.zero, .one, .one, .zero, .zero, .one],
        [.one, .zero, .zero, .one, .zero, .one],
        [.one, .zero, .one, .zero, .one, .zero],
        [.zero, .one, .zero, .one, .one, .zero],
        [.zero, .zero, .one, .one, .zero, .one],
        [.one, .one, .zero, .zero, .one, .zero],
    ])

let level5 = Level.create(
    title: "5",
    boardDefinition: [
        [.zero, .zero, nil, nil, nil, nil],
        [.one, .one, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, .one, .zero],
        [nil, nil, nil, nil, .zero, .zero],
    ], conditions: [
        (.opposite, (0, 2), (0, 3)),
        (.equal, (1, 2), (1, 3)),
        (.equal, (4, 2), (4, 3)),
        (.opposite, (5, 2), (5, 3)),
    ],
    solvedCells: [
        [.zero, .zero, .one, .zero, .one, .one],
        [.one, .one, .zero, .zero, .one, .zero],
        [.zero, .zero, .one, .one, .zero, .one],
        [.zero, .zero, .one, .one, .zero, .one],
        [.one, .one, .zero, .zero, .one, .zero],
        [.one, .one, .zero, .one, .zero, .zero],
    ])

// Difficulty: HARD
let level6 = Level.create(
    title: "6",
    boardDefinition: [
        [.zero, .zero, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, .zero, .one, nil],
        [nil, .zero, .one, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, .one, .one],
    ],
    conditions: [
        (.opposite, (0, 4), (0, 5)),
        (.opposite, (5, 0), (5, 1)),
        (.opposite, (1, 1), (2, 1)),
        (.equal, (1, 5), (2, 5)),
        (.equal, (3, 0), (4, 0)),
        (.equal, (3, 4), (4, 4)),
    ],
    solvedCells: [
        [.zero, .zero, .one, .one, .zero, .one],
        [.one, .zero, .zero, .one, .one, .zero],
        [.zero, .one, .one, .zero, .one, .zero],
        [.one, .zero, .one, .zero, .zero, .one],
        [.one, .one, .zero, .one, .zero, .zero],
        [.zero, .one, .zero, .zero, .one, .one],
    ])

// Difficulty: HARD
let level7 = Level.create(
    title: "7",
    boardDefinition: [
        [.zero, .one, .one, nil, nil, nil],
        [nil, .zero, nil, nil, nil, nil],
        [nil, .one, nil, nil, nil, nil],
        [nil, nil, nil, nil, .zero, nil],
        [nil, nil, nil, nil, .zero, nil],
        [nil, nil, nil, .zero, .one, .zero],
    ],
    conditions: [
        (.opposite, (1, 3), (1, 4)),
        (.opposite, (1, 4), (1, 5)),
        (.opposite, (4, 0), (4, 1)),
        (.opposite, (4, 1), (4, 2)),
        (.equal, (3, 0), (4, 0)),
        (.opposite, (4, 0), (5, 0)),
        (.opposite, (1, 5), (2, 5)),
    ],
    solvedCells: [
        [.zero, .one, .one, .zero, .one, .zero],
        [.one, .zero, .zero, .one, .zero, .one],
        [.one, .one, .zero, .zero, .one, .zero],
        [.zero, .zero, .one, .one, .zero, .one],
        [.zero, .one, .zero, .one, .zero, .one],
        [.one, .zero, .one, .zero, .one, .zero],
    ])

let level8 = Level.create(
    title: "8",
    boardDefinition: [
        [nil, nil, .zero, .zero, nil, nil],
        [.one, .zero, nil, nil, .zero, .zero],
        [nil, nil, .one, .zero, nil, nil],
        [.zero, nil, nil, nil, nil, .one],
        [nil, .one, nil, nil, .zero, nil],
        [nil, nil, .zero, .one, nil, nil],
    ],
    conditions: [
        (.opposite, (3, 2), (4, 2)),
        (.opposite, (3, 3), (4, 3))
    ],
    solvedCells: [
        [.zero, .one, .zero, .zero, .one, .one],
        [.one, .zero, .one, .one, .zero, .zero],
        [.one, .zero, .one, .zero, .one, .zero],
        [.zero, .one, .zero, .one, .zero, .one],
        [.zero, .one, .one, .zero, .zero, .one],
        [.one, .zero, .zero, .one, .one, .zero],
    ])

let level9 = Level.create(
    title: "9",
    boardDefinition: [
        [nil, nil, nil, nil, nil, nil],
        [nil, .zero, nil, nil, .zero, nil],
        [nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil],
        [nil, .one, nil, nil, .one, nil],
        [nil, nil, nil, nil, nil, nil],
    ],
    conditions: [
        (.opposite, (0, 4), (0, 5)),
        (.opposite, (1, 2), (0, 3)),
        (.opposite, (2, 3), (2, 4)),
        (.equal, (3, 1), (3, 2)),
        (.equal, (4, 2), (4, 3)),
        (.equal, (5, 0), (5, 1)),
        (.equal, (2, 0), (3, 0)),
        (.opposite, (2, 5), (3, 5))
    ],
    solvedCells: [
        [.one, .one, .zero, .zero, .one, .zero],
        [.one, .zero, .zero, .one, .zero, .one],
        [.zero, .zero, .one, .one, .zero, .one],
        [.zero, .one, .one, .zero, .one, .zero],
        [.one, .one, .zero, .zero, .one, .zero],
        [.zero, .zero, .one, .one, .zero, .one]
    ])

// Difficulty: Hard
let level10 = Level.create(
    title: "10",
    boardDefinition: [
        [.zero, nil, nil, nil, nil, .zero],
        [nil, .one, nil, nil, .zero, nil],
        [nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil],
        [nil, .zero, nil, nil, .zero, nil],
        [.zero, nil, nil, nil, nil, .one],
    ],
    conditions: [
        (.opposite, (2, 2), (2, 3)),
        (.opposite, (3, 2), (3, 3)),
        (.equal, (2, 2), (3, 2)),
        (.equal, (2, 3), (3, 3)),
    ], solvedCells: [
        [.zero, .one, .zero, .one, .one, .zero],
        [.one, .one, .zero, .one, .zero, .zero],
        [.one, .zero, .one, .zero, .zero, .one],
        [.zero, .one, .one, .zero, .one, .zero],
        [.one, .zero, .zero, .one, .zero, .one],
        [.zero, .zero, .one, .zero, .one, .one],
    ])

let testLevel1 = Level.create(
    title: "n/a",
    boardDefinition: [
        [nil, nil, nil, nil, nil, nil],
        [.zero, .one, nil, nil, nil, nil],
        [.zero, .zero, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil]
    ],
    conditions: [
        (.equal, (1, 0), (1, 1)),
        (.opposite, (2, 0), (2, 1)),
        (.opposite, (1, 0), (2, 0))
    ]
)

let testLevel2 = Level.create(
    title: "n/a",
    boardDefinition: [
        [.zero, .zero, .one, .zero, .one, .zero],
        [.zero, nil, nil, nil, nil, nil],
        [.one, nil, nil, nil, nil, nil],
        [.zero, nil, nil, nil, nil, nil],
        [.one, nil, nil, nil, nil, nil],
        [.zero, nil, nil, nil, nil, nil]
    ],
    conditions: [ ]
)

let testLevel3 = Level.create(
    title: "n/a",
    boardDefinition: [
        [.zero, .zero, .zero, nil, nil, nil],
        [.zero, nil, nil, nil, nil, nil],
        [.zero, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil]
    ],
    conditions: [ ]
)

let testLevel4 = Level.create(
    title: "n/a",
    boardDefinition: [
        [nil, nil, nil, nil, nil, nil],
        [nil, .zero, .one, nil, nil, nil],
        [nil, .zero, .one, nil, nil, nil],
        [nil, nil, .zero, nil, nil, nil],
        [nil, nil, .one, nil, nil, nil],
        [nil, .zero, .one, nil, nil, nil]
    ],
    conditions: [ ]
)
