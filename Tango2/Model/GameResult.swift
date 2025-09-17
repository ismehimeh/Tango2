//
//  GameResult.swift
//  Tango2
//
//  Created by Sergei Vasilenko on 15.08.2025.
//

import SwiftData

@Model
class GameResult {

    var solvedLevel: Level
    var secondsSpent: Int
    var hintsUsed: Int
    var undosUsed: Int

    init(solvedLevel: Level, secondsSpent: Int, hintsUsed: Int, undosUsed: Int) {
        self.solvedLevel = solvedLevel
        self.secondsSpent = secondsSpent
        self.hintsUsed = hintsUsed
        self.undosUsed = undosUsed
    }
}
