//
//  GameCondition.swift
//  Tango
//
//  Created by Sergei Vasilenko on 11.03.2025.
//

import Foundation

struct GameCellCondition: Identifiable, Hashable {
    enum Condition: Hashable {
        case equal
        case opposite
        
        var symbol: String {
            switch self {
            case .equal:
                return "="
            case .opposite:
                return "X"
            }
        }
    }

    let id = UUID()
    let condition: Condition
    let cellA: CellPosition
    let cellB: CellPosition
}

struct CellPosition: Equatable, Hashable {
    let row: Int
    let column: Int
}
