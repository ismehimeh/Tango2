//
//  GameView.swift
//  Tango2
//
//  Created by Sergei Vasilenko on 9.06.2025.
//

import SwiftUI

struct GameView: View {

    enum Constants {
        static let cellPrefilledBackgroundColor = Color.init(red: 238 / 255.0, green: 234 / 255.0, blue: 232 / 255.0)
        static let cellBackgroundColor = Color.white
        static let fieldBackgroundColor = Color.init(red: 234 / 255.0, green: 227 / 255.0, blue: 217 / 255.0)
    }
    
    @State var viewModel: GameViewModel
    @State var cellEntries: [CellFramePreferenceKeyEntry] = []

    // MARK: - Views
    var body: some View {
        ScrollView {
            VStack {
                topView
                gameFieldView
                undoAndHintView
                howToPlayView
            }
            .padding(.horizontal, 15)
        }
        .toolbar {
            Button {
                viewModel.tapSettings()
            } label: {
                Image(systemName: "gearshape.fill")
            }
        }
        .onAppear {
            viewModel.startTimer()
        }
//        .sheet(item: $store.scope(state: \.settings, action: \.settings)){ settingsStore in
//            SettingsView(store: settingsStore)
//                .presentationDetents([.medium])
//                .presentationDragIndicator(.visible)
//        }
    }

    var topView: some View {
        HStack {
            if viewModel.isClockVisible {
                Image(systemName: "clock")
                Text(viewModel.timeString)
            }
            Spacer()
            Button {
                viewModel.tapClear()
            } label: {
                Text("Clear")
                    .padding(.horizontal, 5)
            }
            .buttonStyle(.bordered)
            .buttonBorderShape(.capsule)
        }
//        .alert($store.scope(state: \.alert, action: \.alert))
    }

    var gameFieldView: some View {
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
                                viewModel.tapCell(i, j)
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
                ForEach(viewModel.game.gameConditions) { condition in
                    let cellA = cellEntries.last(where: { $0.row == condition.cellA.0 && $0.column == condition.cellA.1})
                    let cellB = cellEntries.last(where: { $0.row == condition.cellB.0 && $0.column == condition.cellB.1})
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
            if viewModel.isMistake && viewModel.isMistakeVisible {
                Color.red.opacity(0.2)
                    .allowsHitTesting(false)
            }
            if viewModel.isSolved {
                Color.green.opacity(0.2)
                    .allowsHitTesting(false)
            }
        }
    }

    var undoAndHintView: some View {
        HStack {
            Button {
                print("Undo!")
            } label: {
                Text("Undo")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .buttonBorderShape(.capsule)

            Button {
                print("Hint!")
            } label: {
                Text("Hint")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .buttonBorderShape(.capsule)
        }
    }

    var howToPlayView: some View {
        DisclosureGroup("How to play") {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("•")
                    Text("Fill the grid so that each cell contains either a 🌞 or a 🌚.")
                }

                HStack {
                    Text("•")
                    Text("No more than 2 🌞 or 🌚 may be next to each other, either vertically or horizontally.")
                }

                HStack {
                    Text("•")
                    Text("🌞🌞✅")
                }
                .padding(.leading, 20)

                HStack {
                    Text("•")
                    Text("🌞🌞🌞❌")
                }
                .padding(.leading, 20)

                HStack {
                    Text("•")
                    Text("Each row (and column) must contain the same number of 🌞 and 🌚 .")
                }

                HStack {
                    Text("•")
                    Text("Cells separated by an **=** sign must be of the same type.")
                }

                HStack {
                    Text("•")
                    Text("Cells separated by an **X** sign must be of the opposite type.")
                }

                HStack {
                    Text("•")
                    Text("Each puzzle has one right answer and can be solved via deduction (you should never have to make a guess).")
                }
            }
        }
        .frame(width: 300)
    }

    // MARK: - Functions
    func cellBackgroundColor(_ i: Int, _ j: Int) -> Color {
        let cell = viewModel.game.gameCells[i][j]
        if let _ = cell.predefinedValue {
            return Constants.cellPrefilledBackgroundColor
        } else {
            return Constants.cellBackgroundColor
        }
    }

    func cellValue(_ i: Int, _ j: Int) -> String? {
        let cell = viewModel.game.gameCells[i][j]

        if let value = cell.predefinedValue {
            return value == 0 ? "🌞" : "🌚"
        }

        if let value = cell.value {
            return value == 0 ? "🌞" : "🌚"
        }

        return nil
    }
}

#Preview {
    GameView(viewModel: .init(.init(level1)))
}
