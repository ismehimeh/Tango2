//
//  ContentView.swift
//  Tango2
//
//  Created by Sergei Vasilenko on 9.06.2025.
//

import SwiftUI

struct LevelsView: View {

    @Binding var levels: [Level]
    @State private var games: [Level.ID: Game] = [:]

    let columns = [
        GridItem(.adaptive(minimum: 80))
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
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
                let binding = Binding(get: { games[level.id] ?? Game(level) },
                                      set: { games[level.id] = $0 })
                GameView(game: binding)
            }
        }
    }
}

#Preview {
    @Previewable @State var levels = (1...100).map { Level(title: "\($0)",
                                       gameCells: level1Cells,
                                       gameConditions: level1Conditions) }
    return LevelsView(levels: $levels)
}
