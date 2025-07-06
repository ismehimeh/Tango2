//
//  AppState.swift
//  Tango2
//
//  Created by Sergei Vasilenko on 22.06.2025.
//

import SwiftUI

@Observable
final class AppState {
    let levels: [Level] = [level1, level2, level3, level4]
    var games: [Level.ID: Game] = [:]
    
    func resetAllGames() {
        games = [:]
    }
}
