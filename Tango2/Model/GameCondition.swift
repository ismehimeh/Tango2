//
//  GameCondition.swift
//  Tango
//
//  Created by Sergei Vasilenko on 11.03.2025.
//

import Foundation
import SwiftData

@Model
class Condition: Identifiable {

    enum Sign: Hashable, Codable {
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

    var id = UUID()
    var condition: Sign
    var cellA: CellPosition
    var cellB: CellPosition

    init(condition: Sign,
         cellA: CellPosition,
         cellB: CellPosition)
    {
        self.condition = condition
        self.cellA = cellA
        self.cellB = cellB
    }
}

extension Condition: Equatable {

    static func == (lhs: Condition, rhs: Condition) -> Bool {
        lhs.condition == rhs.condition &&
        lhs.cellA == rhs.cellA &&
        lhs.cellB == rhs.cellB
    }
}

extension Condition: Hashable {

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct CellPosition: Equatable, Hashable, Codable {
    let row: Int
    let column: Int
}
