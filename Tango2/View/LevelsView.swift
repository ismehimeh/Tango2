//
//  ContentView.swift
//  Tango2
//
//  Created by Sergei Vasilenko on 9.06.2025.
//

import SwiftUI

struct LevelsView: View {

    var levels: [Level]
    @Environment(AppState.self) private var state
    @State private var router = Router(path: NavigationPath())
    @State private var showingDebugMenu = false

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
    var levels = (1...100).map { _ in level1 }
    LevelsView(levels: levels)
}


