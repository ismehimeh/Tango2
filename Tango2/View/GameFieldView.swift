//
//  GameFieldView.swift
//  Tango2
//
//  Created by Sergei Vasilenko on 9.06.2025.
//

import SwiftUI

struct GameFieldView: View {
    
    @State var cellEntries: [CellFramePreferenceKeyEntry] = [] // what the fuck is that?
    @Binding var game: Game
    
    @State private var isMistakeVisible = true
    
    enum Constants {
        static let cellPrefilledBackgroundColor = Color.init(red: 238 / 255.0, green: 234 / 255.0, blue: 232 / 255.0)
        static let cellBackgroundColor = Color.white
        static let fieldBackgroundColor = Color.init(red: 234 / 255.0, green: 227 / 255.0, blue: 217 / 255.0)
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundStyle(Constants.fieldBackgroundColor)
                .aspectRatio(1, contentMode: .fit)
            Grid(horizontalSpacing: 2, verticalSpacing: 2) {
                ForEach(0..<6) { i in
                    GridRow {
                        ForEach(0..<6) { j in
                            ZStack {
                                CellView(row: i,
                                         column: j,
                                         backgroundColor: cellBackgroundColor(i, j),
                                         cellContent: cellValue(i, j))
                            }
                            .onTapGesture {
                                tapCell(i, j)
                            }
                        }
                    }
                }
            }
            .padding(2)
            .onPreferenceChange(CellFramePreferenceKey.self) { value in
                cellEntries = value
            }
            .coordinateSpace(name: "grid")

            ZStack {
                ForEach(game.gameConditions) { condition in
                    let cellA = cellEntries.last(where: { $0.row == condition.cellA.row && $0.column == condition.cellA.column})
                    let cellB = cellEntries.last(where: { $0.row == condition.cellB.row && $0.column == condition.cellB.column})
                    if let cellA = cellA, let cellB = cellB {
                        let midPoint = CGPoint(x: (cellA.rect.midX + cellB.rect.midX) / 2,
                                               y: (cellA.rect.midY + cellB.rect.midY) / 2)
                        ConditionView(condition: condition.condition)
                            .position(midPoint)
                    }
                }
            }
        }
        .overlay {
            if !game.isFieldValid() && isMistakeVisible {
                Color.red.opacity(0.2)
                    .allowsHitTesting(false)
            }
            if game.isSolved() {
                Color.green.opacity(0.2)
                    .allowsHitTesting(false)
            }
        }
    }
    
    // MARK: - Functions
    func cellBackgroundColor(_ i: Int, _ j: Int) -> Color {
        let cell = game.gameCells[i][j]
        if let _ = cell.predefinedValue {
            return Constants.cellPrefilledBackgroundColor
        } else {
            return Constants.cellBackgroundColor
        }
    }

    func cellValue(_ i: Int, _ j: Int) -> String? {
        let cell = game.gameCells[i][j]

        if let value = cell.predefinedValue {
            return value == 0 ? "🌞" : "🌚"
        }

        if let value = cell.value {
            return value == 0 ? "🌞" : "🌚"
        }

        return nil
    }
    
    func tapCell(_ i: Int, _ j: Int) {
        $game.wrappedValue.toogleCell(i, j)
    }
}

#Preview {
    GameFieldView(game: .constant(.init(level1)))
        .aspectRatio(1, contentMode: .fit)
        .padding()
}
