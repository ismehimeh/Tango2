//
//  GameViewModel.swift
//  Tango2
//
//  Created by Sergei Vasilenko on 9.06.2025.
//

import Combine
import SwiftData
import SwiftUI

@Observable
class GameViewModel {
    
    var timeString = "0:00"
    private var lastActionTime = Date.now
    
    private(set) var idleTimeoutPassed = false
    
    var secondsPassed = 0 {
        didSet {
            timeString = String(format: "%01d:%02d", secondsPassed / 60, secondsPassed % 60)
        }
    }
    
    private let totalTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    private var timerCancellable: AnyCancellable?
    
    func startTimer() {
        timerCancellable = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self else { return }
                secondsPassed += 1
                idleTimeoutPassed = abs(lastActionTime.timeIntervalSinceNow) > 60
            }
    }
    
    func stopStimer() {
        timerCancellable = nil
    }
    
    func cellTapped() {
        lastActionTime = Date.now
        idleTimeoutPassed = false
    }
    
    func saveResult(_ modelContext: ModelContext, level: Level) {
        let result = GameResult(solvedLevel: level, secondsSpent: secondsPassed, hintsUsed: 5, undosUsed: 6)
        modelContext.insert(result)
        level.isSolved = true
        try! modelContext.save()
    }
}
