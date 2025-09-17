//
//  Tango2App.swift
//  Tango2
//
//  Created by Sergei Vasilenko on 9.06.2025.
//

import SwiftData
import SwiftUI

@main
struct Tango2App: App {
    @State private var appState: AppState
    private let isLevelsPersistedKey = "isLevelsPersisted"
    private let modelContainer: ModelContainer?

    init() {
        let configuration = ModelConfiguration(for: Level.self, GameResult.self)
        do {
            modelContainer = try ModelContainer(for: Level.self, GameResult.self, configurations: configuration)
        } catch {
            modelContainer = nil
            fatalError("Failed to initialize ModelContainer: \(error)")
        }

        GameSettings.registerDefaults()

        if
            !UserDefaults.standard.bool(forKey: isLevelsPersistedKey),
            let modelContainer = modelContainer
        {
            let context = modelContainer.mainContext
            let levels = [level1, level2, level3, level4, level5, level6, level7, level8, level9, level10, level11]
            try? context.transaction {
                for level in levels {
                    context.insert(level)
                }
            }
            try? context.save()
            UserDefaults.standard.set(true, forKey: isLevelsPersistedKey)
        }

        appState = AppState(modelContainer?.mainContext)
    }

    var body: some Scene {
        WindowGroup {
            if let modelContainer = modelContainer {
                LevelsView(levels: appState.levels)
                    .environment(appState)
                    .modelContainer(modelContainer)
            } else {
                Text("Failed to initialize ModelContainer.")
            }
        }
    }
}
