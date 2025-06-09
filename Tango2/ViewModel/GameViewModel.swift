//
//  GameViewModel.swift
//  Tango2
//
//  Created by Sergei Vasilenko on 9.06.2025.
//

import SwiftUI
import Combine

@Observable
class GameViewModel {
    
    var gameFieldViewModel: GameFieldViewModel
    
    init(_ game: Game) {
        gameFieldViewModel =  GameFieldViewModel(game: game)
    }
    
    var isClockVisible: Bool = true
    var timeString = "0:00"
    var isMistakeVisible: Bool = true
    var isMistake: Bool = false
    var isSolved: Bool = false
    var mistakeValidationID: UUID?
    
    var showingClearAlert = false
    var showingSettings = false
    var showingResult = false
    var timerCancellable: AnyCancellable?
    
    let timer = Timer.publish(every: 1, on: .main, in: .common)
        .autoconnect()
    
    var secondsPassed = 0 {
        didSet {
            timeString = String(format: "%01d:%02d", secondsPassed / 60, secondsPassed % 60)
        }
    }
    
    func tapSettings() {
        showingSettings = true
    }
    
    func startTimer() {
        timerCancellable = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.secondsPassed += 1
            }
    }
    
    func tapClear() {
        showingClearAlert = true
    }
    
    func confirmClear() {
        gameFieldViewModel.clearField()
    }
}
