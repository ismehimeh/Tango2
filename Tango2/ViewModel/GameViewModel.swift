//
//  GameViewModel.swift
//  Tango2
//
//  Created by Sergei Vasilenko on 9.06.2025.
//
import SwiftUI

@Observable
class GameViewModel {
    
    var game: Game
    
    init(_ game: Game) {
        self.game = game
    }
    
    var isClockVisible: Bool = false
    var timeString = "00:00:00"
    var isMistakeVisible: Bool = true
    var isMistake: Bool = false
    var isSolved: Bool = false
    var mistakeValidationID: UUID?
    
    var showingClearAlert = false
    var showingSettings = false
    var showingResult = false
    
    func tapSettings() {
        showingSettings = true
    }
    
    func startTimer() {
        // just make a timer and start  it
    }
    
    func tapClear() {
        showingClearAlert = true
    }
    
    func confirmClear() {
        game.gameCells = game.gameCells.map { row in
            row.map { cell in
                GameCell(predefinedValue: cell.predefinedValue)
            }
        }
        isMistake = game.isFieldValid()
        isSolved = game.isSolved()
    }
}
