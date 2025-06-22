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
    
    var timeString = "0:00"
    
    private var secondsPassed = 0 {
        didSet {
            timeString = String(format: "%01d:%02d", secondsPassed / 60, secondsPassed % 60)
        }
    }
    
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    private var timerCancellable: AnyCancellable?
    
    func startTimer() {
        timerCancellable = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.secondsPassed += 1
            }
    }
}
