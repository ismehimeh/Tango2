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
    
    func tapSettings() {
        // show settings via GameView navigation link
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
    
    func tapCell(_ i: Int, _ j: Int) {
        let cell = game.gameCells[i][j]
        guard cell.predefinedValue == nil else { return }

        if cell.value == nil {
            game.gameCells[i][j].value = 0
        }
        else if cell.value == 0 {
            game.gameCells[i][j].value = 1
        }
        else {
            game.gameCells[i][j].value = nil
        }
        
        let mistakeId = UUID()
        mistakeValidationID = mistakeId
        isMistake = false
        isSolved = game.isSolved()
        
        Task {
            try await Task.sleep(for: .seconds(1))
            await validateMistake(mistakeId)
        }
    }
    
    @MainActor
    func validateMistake(_ id: UUID) {
        guard id == mistakeValidationID else { return }
        isMistake = !game.isFieldValid()
    }
}
