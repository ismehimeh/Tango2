//
//  Tango2App.swift
//  Tango2
//
//  Created by Sergei Vasilenko on 9.06.2025.
//

import SwiftUI

@main
struct Tango2App: App {
    @State private var appState = AppState()
    
    init() {
        GameSettings.registerDefaults()
    }
    
    var body: some Scene {
        WindowGroup {
            LevelsView(levels: appState.levels)
                .environment(appState)
        }
    }
}
