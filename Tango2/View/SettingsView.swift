//
//  SettingsView.swift
//  Tango2
//
//  Created by Sergei Vasilenko on 9.06.2025.
//

import SwiftUI

struct SettingsView: View {

    @AppStorage(GameSettings.clockVisibleKey) private var isClockVisible = GameSettings.defaultClockVisible
    @AppStorage(GameSettings.mistakeHighlightKey) private var isMistakeHighlightEnabled = GameSettings.defaultMistakeHighlight

    var body: some View {
        HStack {
            Label("Show clock", systemImage: "clock")
            Spacer()
            Toggle("", isOn: $isClockVisible)
        }
        .padding(.horizontal, 20)
        .padding(.top, 40)

        HStack {
            Label("Highlight mistakes", systemImage: "exclamationmark.triangle.fill")
            Spacer()
            Toggle("", isOn: $isMistakeHighlightEnabled)
        }
        .padding(.horizontal, 20)

        Spacer()
    }
}

#Preview {
    SettingsView()
}
