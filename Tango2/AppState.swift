//
//  AppState.swift
//  Tango2
//
//  Created by Sergei Vasilenko on 22.06.2025.
//

import SwiftUI

@Observable
final class AppState {
    var games: [Level.ID: Game] = [:]
    
    func resetAllGames() {
        games = [:]
    }
}
