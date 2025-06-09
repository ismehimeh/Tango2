//
//  SettingsView.swift
//  Tango2
//
//  Created by Sergei Vasilenko on 9.06.2025.
//

import SwiftUI

struct SettingsView: View {
    
    @State var viewModel = SettingsViewModel()
    
    var body: some View {
        HStack {
            Label("Show clock", systemImage: "clock")
            Spacer()
            Toggle("", isOn: $viewModel.isShowClockIsOn)
        }
        .padding(.horizontal, 20)
        .padding(.top, 40)
        
        HStack {
            Label("Auto-check", systemImage: "checkmark.seal.fill")
            Spacer()
            Toggle("", isOn: $viewModel.isAutoCheckInOn)
        }
        .padding(.horizontal, 20)
        
        Spacer()
    }
}

#Preview {
    SettingsView(viewModel: .init())
}
