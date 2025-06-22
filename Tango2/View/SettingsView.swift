//
//  SettingsView.swift
//  Tango2
//
//  Created by Sergei Vasilenko on 9.06.2025.
//

import SwiftUI

struct SettingsView: View {
    
    @State private var isShowClockIsOn: Bool = false
    @State private var isAutoCheckInOn: Bool = false
    
    var body: some View {
        HStack {
            Label("Show clock", systemImage: "clock")
            Spacer()
            Toggle("", isOn: $isShowClockIsOn)
        }
        .padding(.horizontal, 20)
        .padding(.top, 40)
        
        HStack {
            Label("Auto-check", systemImage: "checkmark.seal.fill")
            Spacer()
            Toggle("", isOn: $isAutoCheckInOn)
        }
        .padding(.horizontal, 20)
        
        Spacer()
    }
}

#Preview {
    SettingsView()
}
