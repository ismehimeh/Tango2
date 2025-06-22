//
//  ContentView.swift
//  Tango2
//
//  Created by Sergei Vasilenko on 9.06.2025.
//

import SwiftUI

struct LevelsView: View {

    @Binding var levels: [Level]
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
                let binding = Binding(get: { state.games[level.id] ?? Game(level) },
                                      set: { state.games[level.id] = $0 })
                GameView(game: binding)
            }
        }
        .environment(router)
        .sheet(isPresented: $showingDebugMenu) {
            DebugMenuView()
        }
    }
}

#Preview {
    @Previewable @State var levels = (1...100).map { Level(title: "\($0)",
                                       gameCells: level1Cells,
                                       gameConditions: level1Conditions) }
    return LevelsView(levels: $levels)
}

@Observable
class Router {
    var path: NavigationPath
    
    init(path: NavigationPath) {
        self.path = path
    }
}
