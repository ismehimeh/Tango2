//
//  DebugMenuView.swift
//  Tango2
//
//  Created by Sergei Vasilenko on 22.06.2025.
//

import SwiftUI

struct DebugMenuView: View {
    
    @Environment(AppState.self) private var state
    
    var body: some View {
        VStack(alignment: .leading) {
            Button("Reset all levels") {
                state.resetAllGames()
            }
            .buttonStyle(.bordered)
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(10)
    }
}

#Preview {
    DebugMenuView()
}
    
