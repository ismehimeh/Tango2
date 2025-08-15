//
//  Game+Hints.swift
//  Tango2
//
//  Created by Sergei Vasilenko on 10.07.2025.
//

// - MARK: Mistakes

typealias Sign = GameCellCondition.Condition

// TODO: hints are designed specifically for 6x6 levels - should I update them for 4x4?

/// Represents the type of line being processed (row or column)
enum LineType {
    case row(index: Int)
    case column(index: Int)
    
    var index: Int {
        switch self {
        case .row(let index), .column(let index):
            return index
        }
    }
    
    var name: String {
        switch self {
        case .row: return "row"
        case .column: return "column"
        }
    }
}
