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
                        if let result = results.first(where: { $0.solvedLevel == level }) {
                            NavigationLink(value: result) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.gray)
                                        .frame(width: 80, height: 80)
                                    Text(level.title)
                                        .foregroundColor(.white)
                                }
                            }
                        }
                        else {
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
            .navigationDestination(for: GameResult.self) { result in
                ResultView(gameResult: result, showButtons: false)
            }
        }
        .environment(router)
        .sheet(isPresented: $showingDebugMenu) {
            DebugMenuView()
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: GameResult.self, configurations: config)
    var appState = AppState(container.mainContext)
    let level4 = level4
    
    let result = GameResult(solvedLevel: level4, secondsSpent: 10, hintsUsed: 3, undosUsed: 4)
    
    container.mainContext.insert(result)
    
    var levels = [level1, level2, level3, level4, level5]
    return LevelsView(levels: levels)
        .environment(appState)
        .modelContainer(container)
}


