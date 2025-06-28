//
//  GameFieldView.swift
//  Tango2
//
//  Created by Sergei Vasilenko on 9.06.2025.
//

import SwiftUI

struct GameFieldView: View {
    
    // As I remember, idea behind all of this
    // is to get frames of cells to properly position ConditionViews
    @State var cellEntries: [CellFramePreferenceKeyEntry] = [] // what the fuck is that?
    var game: Game
    @Binding var showMistake: Bool
    @Binding var showSolved: Bool
    
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
                ForEach(0..<game.lineLength) { i in
                    GridRow {
                        ForEach(0..<game.lineLength) { j in
                            ZStack {
                                CellView(row: i,
                                         column: j,
                                         backgroundColor: cellBackgroundColor(i, j),
                                         cellContent: cellValue(i, j), isMarkedAsMistake: $showMistake)
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
            if showMistake {
                Color.red.opacity(0.2)
                    .allowsHitTesting(false)
            }
            if showSolved {
                Color.green.opacity(0.2)
                    .allowsHitTesting(false)
            }
        }
    }
    
    // MARK: - Functions
    func cellBackgroundColor(_ i: Int, _ j: Int) -> Color {
        let cell = game.cell(at: i, column: j)
        if let _ = cell.predefinedValue {
            return Constants.cellPrefilledBackgroundColor
        } else {
            return Constants.cellBackgroundColor
        }
    }

    func cellValue(_ i: Int, _ j: Int) -> String? {
        let cell = game.cell(at: i, column: j)

        if let value = cell.predefinedValue {
            return value == .zero ? "🌞" : "🌚"
        }

        if let value = cell.value {
            return value == .zero ? "🌞" : "🌚"
        }

        return nil
    }
    
    func tapCell(_ i: Int, _ j: Int) {
        game.toggleCell(i, j)
    }
}

#Preview {
    GameFieldView(game: .init(level1),
                  showMistake: .constant(false),
                  showSolved: .constant(false))
        .aspectRatio(1, contentMode: .fit)
        .padding()
}
