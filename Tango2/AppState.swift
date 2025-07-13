//
//  AppState.swift
//  Tango2
//
//  Created by Sergei Vasilenko on 22.06.2025.
//

import SwiftUI

@Observable
final class AppState {
    let levels: [Level] = [level1, level2, level3, level4, level5, level6, level7]
    var games: [Level.ID: Game] = [:]
    private var levelIndex: Int = 0
    
    func resetAllGames() {
        games = [:]
    }
    
    func setCurrentLevel(_ index: Int) {
        guard index >= 0 && index < levels.count else { return }
        levelIndex = index
    }
    
    func moveToNextLevel() -> Bool {
        let nextIndex = levelIndex + 1
        if nextIndex < levels.count {
            levelIndex = nextIndex
            return true
        }
        return false
    }
    
    var isNextLevelAvailable: Bool {
        levelIndex + 1 < levels.count
    }
    
    var currentLevel: Level {
        levels[levelIndex]
    }
    
    func updateIndex(accordingTo level: Level) {
        if let index = levels.firstIndex(of: level) {
            levelIndex = index
        }
    }
}
