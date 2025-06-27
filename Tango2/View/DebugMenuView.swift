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
    
    var body: some View {
        VStack(alignment: .leading) {
            Button("Reset all levels") {
                state.resetAllGames()
            }
            Button(isRedoVisible ? "Make Redo invisible" : "Make Redo visible") {
                isRedoVisible.toggle()
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
    
