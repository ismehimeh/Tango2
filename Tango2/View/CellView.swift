//
//  CellView.swift
//  Tango
//
//  Created by Sergei Vasilenko on 10.03.2025.
//

import SwiftUI

struct CellView: View {
    let row: Int
    let column: Int
    let backgroundColor: Color
    let cellContent: String?
    let isMarkedAsMistake: Bool

    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(backgroundColor)
            if isMarkedAsMistake {
                Color.red.opacity(0.5)
            }
            if let text = cellContent {
                Text(text)
                    .font(.title)
            }
        }
        .background(
            GeometryReader { geo in
                Color.clear
                    .preference(
                        key: CellFramePreferenceKey.self,
                        value: [CellFramePreferenceKeyEntry(row: row,
                                                            column: column,
                                                            rect: geo.frame(in: .named("grid")))]
                    )
            }
        )
    }
}

#Preview {
    return CellView(row: 0, column: 0,
                    backgroundColor: .gray,
                    cellContent: "🌞",
                    isMarkedAsMistake: false)
    .frame(width: 50, height: 50)
}

#Preview("Mistaken") {
    return CellView(row: 0, column: 0,
                    backgroundColor: .gray,
                    cellContent: "🌞",
                    isMarkedAsMistake: true)
    .frame(width: 50, height: 50)
}
