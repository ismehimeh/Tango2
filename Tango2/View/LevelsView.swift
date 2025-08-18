//
//  ContentView.swift
//  Tango2
//
//  Created by Sergei Vasilenko on 9.06.2025.
//

import SwiftData
import SwiftUI

struct LevelsView: View {

    var levels: [Level]
    @Environment(AppState.self) private var state
    @State private var router = Router(path: NavigationPath())
    @State private var showingDebugMenu = false
    // TODO: temp
    @Query private var results: [GameResult]

    let columns = [
        GridItem(.adaptive(minimum: 80))
    ]

    var body: some View {
        NavigationStack(path: $router.path) {
            ScrollView {
                #if DEBUG
                Button("Debug Menu") {
                    showingDebugMenu.toggle()
                }
                #endif
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(levels) { level in
                        NavigationLink(value: level) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.blue)
                                    .frame(width: 80, height: 80)
                                Text(level.title)
                                    .foregroundColor(.white)
                            }
                        }
                    }
                }
                
                if !results.isEmpty {
                    VStack {
                        Text("WIP Results")
                            .font(.title)
                        Text("Number of results \(results.count)")
                    }
                }
            }
            .navigationDestination(for: Level.self) { level in
                GameView(game: {
                    if let existingGame = state.games[level.id] {
                        return existingGame
                    } else {
                        let newGame = Game(level)
                        state.games[level.id] = newGame
                        return newGame
                    }
                }())
                .onAppear {
                    state.updateIndex(accordingTo: level)
                }
            }
        }
        .environment(router)
        .sheet(isPresented: $showingDebugMenu) {
            DebugMenuView()
        }
    }
}

#Preview {
    @Previewable @State var appState = AppState()
    var levels = [level1, level2, level3, level4, level5]
    return LevelsView(levels: levels)
        .environment(appState)
}


