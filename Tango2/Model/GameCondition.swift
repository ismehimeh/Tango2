//
//  GameCondition.swift
//  Tango
//
//  Created by Sergei Vasilenko on 11.03.2025.
//

import Foundation

struct GameCellCondition: Identifiable, Hashable, Equatable {
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
    
    static func == (lhs: GameCellCondition, rhs: GameCellCondition) -> Bool {
        lhs.condition == rhs.condition &&
        lhs.cellA == rhs.cellA &&
        lhs.cellB == rhs.cellB
    }
}

struct CellPosition: Equatable, Hashable {
    let row: Int
    let column: Int
}
