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
    var highlightedCell: CellPosition?
    var notDimmedCells: [CellPosition]
    
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
                ForEach(0..<game.lineLength, id: \.self) { i in
                    GridRow {
                        ForEach(0..<game.lineLength, id: \.self) { j in
                            ZStack {
                                CellView(row: i,
                                         column: j,
                                         backgroundColor: cellBackgroundColor(i, j),
                                         cellContent: cellValue(i, j),
                                         isMarkedAsMistake: isCellWithMistake(i, j), 
                                         isHighlighted: isCellHighlighted(i, j))
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
            
            if highlightedCell != nil || !notDimmedCells.isEmpty {
                cellHighlightMask
            }
        }
        .overlay {
            if showSolved {
                Color.green.opacity(0.2)
                    .allowsHitTesting(false)
            }
        }
    }
    
    func isCellHighlighted(_ i: Int, _ j: Int) -> Bool {
        guard let position = highlightedCell else { return false }
        return position.row == i && position.column == j
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
        return cell.predefinedValue?.symbol ?? cell.value?.symbol
    }
    
    func isCellWithMistake(_ i: Int, _ j: Int) -> Bool {
        return game.isMistakeCell(i: i, j: j)
    }
    
    func tapCell(_ i: Int, _ j: Int) {
        game.toggleCell(i, j)
    }
    
    var cellHighlightMask: some View {
        ZStack {
            Rectangle()
                .fill(Color.black.opacity(0.3))
                .aspectRatio(1, contentMode: .fit)
                .mask {
                    ZStack {
                        Rectangle()
                        
                        // Create a Group to cut out all non-dimmed cells
                        Group {
                            // Cut out the highlighted cell if present
                            if let highlightedCell = highlightedCell,
                               let cellEntry = cellEntries.last(where: { 
                                   $0.row == highlightedCell.row && $0.column == highlightedCell.column
                               }) {
                                Rectangle()
                                    .frame(width: cellEntry.rect.width, height: cellEntry.rect.height)
                                    .position(x: cellEntry.rect.midX, y: cellEntry.rect.midY)
                                    .blendMode(.destinationOut)
                            }
                            
                            // Cut out all cells from notDimmedCells array
                            ForEach(notDimmedCells, id: \.self) { position in
                                if let cellEntry = cellEntries.last(where: {
                                    $0.row == position.row && $0.column == position.column
                                }) {
                                    Rectangle()
                                        .frame(width: cellEntry.rect.width, height: cellEntry.rect.height)
                                        .position(x: cellEntry.rect.midX, y: cellEntry.rect.midY)
                                        .blendMode(.destinationOut)
                                }
                            }
                        }
                    }
                }
        }
        .allowsHitTesting(false) // Allow taps to pass through
    }
}

#Preview {
    GameFieldView(game: .init(level1),
                  showMistake: .constant(false),
                  showSolved: .constant(false),
                  highlightedCell: nil,
                  notDimmedCells: [])
        .aspectRatio(1, contentMode: .fit)
        .padding()
}

#Preview {
    GameFieldView(game: .init(level1),
                  showMistake: .constant(false),
                  showSolved: .constant(false),
                  highlightedCell: .init(row: 1, column: 2),
                  notDimmedCells: [.init(row: 1, column: 3),
                                   .init(row: 1, column: 4)])
        .aspectRatio(1, contentMode: .fit)
        .padding()
}
