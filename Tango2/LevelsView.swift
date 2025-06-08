//
//  ContentView.swift
//  Tango2
//
//  Created by Sergei Vasilenko on 9.06.2025.
//

import SwiftUI

struct LevelsView: View {

    @Binding var viewModel: LevelsViewModel

    let columns = [
        GridItem(.adaptive(minimum: 80))
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(viewModel.levels) { level in
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
}

@Observable
class LevelsViewModel {
    var levels: [Level]
    
    init(levels: [Level]) {
        self.levels = levels
    }
}

#Preview {
    let levels = (1...100).map { Level(title: "\($0)",
                                       gameCells: level1Cells,
                                       gameConditions: level1Conditions) }
    LevelsView(viewModel: .init(levels: levels))
}
