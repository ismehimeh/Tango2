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
    let isHighlighted: Bool
    
    private let hihglightColor = Color(red: 50 / 255.0, green: 108 / 255.0, blue: 215 / 255.0)

    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(backgroundColor)
            if isMarkedAsMistake {
                Stripes()
                    .rotation(.degrees(45))
                    .stroke(lineWidth: 4)
                    .fill(.red)
                    .stroke(.red)
                    .scaleEffect(1.4)
                    .clipped()
            }
            if let text = cellContent {
                Text(text)
                    .font(.title)
            }
            if isHighlighted {
                Rectangle()
                    .strokeBorder(style: .init(lineWidth: 3))
                    .foregroundStyle(hihglightColor)
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

struct Stripes: Shape {
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        
        for xPosition in stride(from: 0, through: width, by: width / 4) {
            path.move(to: CGPoint(x: xPosition, y: 0))
            path.addLine(to: CGPoint(x: xPosition, y: height))
        }
        
        return path
    }
}

#Preview {
    return CellView(row: 0, column: 0,
                    backgroundColor: .gray,
                    cellContent: zeroSymbol,
                    isMarkedAsMistake: false,
                    isHighlighted: false)
    .frame(width: 50, height: 50)
}

#Preview("Mistaken") {
    return CellView(row: 0, column: 0,
                    backgroundColor: .gray,
                    cellContent: zeroSymbol,
                    isMarkedAsMistake: true,
                    isHighlighted: false)
    .frame(width: 50, height: 50)
}

#Preview("Highlighted") {
    return CellView(row: 0, column: 0,
                    backgroundColor: .gray,
                    cellContent: zeroSymbol,
                    isMarkedAsMistake: true,
                    isHighlighted: true)
    .frame(width: 50, height: 50)
}
