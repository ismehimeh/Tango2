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
    var isMistakeVisible: Bool = false
    var isMistake: Bool = false
    var isSolved: Bool = false
    
    func tapSettings() {
        
    }
    
    func startTimer() {
        
    }
    
    func tapClear() {
        
    }
    
    func tapCell(_ i: Int, _ j: Int) {
        
    }
}
