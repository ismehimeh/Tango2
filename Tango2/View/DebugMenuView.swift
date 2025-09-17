//
//  DebugMenuView.swift
//  Tango2
//
//  Created by Sergei Vasilenko on 22.06.2025.
//

import SwiftUI

struct DebugMenuView: View {

    @Environment(AppState.self) private var state
    @AppStorage(GameSettings.redoVisibilityKey) var isRedoVisible = GameSettings.defaultRedoVisibility
    @AppStorage(GameSettings.hintDelayKey) var hintDelay = GameSettings.defaultHintDelay
    @Environment(\.modelContext) var context

    var body: some View {
        VStack(alignment: .leading) {
            Button("Reset all levels") {
                state.resetAllGames()
            }

            Button(isRedoVisible ? "Make Redo invisible" : "Make Redo visible") {
                isRedoVisible.toggle()
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("Hint Delay: \(String(format: "%.1f", hintDelay)) seconds")
                Slider(value: $hintDelay, in: 0...30, step: 0.5) {
                    Text("Hint Delay")
                }
            }

            Button("Clear results") {
                try? context.delete(model: GameResult.self)
                try? context.save()
            }
            Spacer()
        }
        .buttonStyle(.bordered)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(10)
    }
}

#Preview {
    DebugMenuView()
}
