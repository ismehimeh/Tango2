//
//  LevelGridCellView.swift
//  Tango2
//
//  Created by Sergei Vasilenko on 18.08.2025.
//

import SwiftUI

struct LevelGridCellView: View {
    let title: String
    let isSolved: Bool
    let spentTime: String?
    let hints: Int?
    let undos: Int?
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(isSolved ? Color.gray : Color.blue)
                .frame(width: 80, height: 80)
            Text(title)
                .font(.system(size: 64))
                .foregroundStyle(isSolved ? .white.opacity(0.2) : .white)
            VStack {
                if let spentTime {
                    Text(spentTime)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(.white)
                }
                if let hints {
                    Text("Hints: \(hints)")
                        .foregroundStyle(.white)
                }
                if let undos {
                    Text("Undos \(undos)")
                        .foregroundStyle(.white)
                }
            }
        }
    }
}

#Preview {
    ScrollView {
        LevelGridCellView(title: "1", isSolved: false, spentTime: nil, hints: nil, undos: nil)
        LevelGridCellView(title: "2", isSolved: true, spentTime: "3:40", hints: 2, undos: 5)
    }
    
}
