//
//  GameFieldViewModel.swift
//  Tango2
//
//  Created by Sergei Vasilenko on 9.06.2025.
//

import SwiftUI

@Observable
final class GameFieldViewModel {
    var isMistakeVisible: Bool = true
    var isMistake: Bool = false
    var isSolved: Bool = false
    var game: Game
    var mistakeValidationID: UUID?
    
    init(_ level: Level) {
        self.game = .init(level)
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
