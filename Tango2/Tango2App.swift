//
//  Tango2App.swift
//  Tango2
//
//  Created by Sergei Vasilenko on 9.06.2025.
//

import SwiftUI

@main
struct Tango2App: App {
    var body: some Scene {
        @State var levelsViewModel = LevelsViewModel(levels: [level1, level2])
        WindowGroup {
            LevelsView(viewModel: levelsViewModel)
        }
    }
}
