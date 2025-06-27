//
//  GameCell.swift
//  Tango
//
//  Created by Sergei Vasilenko on 11.03.2025.
//

import SwiftUI

enum CellValue: Int, Hashable {
    case zero = 0
    case one = 1
    
    init?(rawValue: Int) {
        switch rawValue {
        case 0: self = .zero
        case 1: self = .one
        default: return nil
        }
    }
}

@Observable
class GameCell: Hashable {
    let predefinedValue: CellValue?
    private var _value: CellValue?

    var value: CellValue? {
        get {
            predefinedValue ?? _value
        }

        set {
            _value = newValue
        }
    }

    init(predefinedValue: CellValue? = nil, value: CellValue? = nil) {
        self.predefinedValue = predefinedValue
        self._value = value
    }
}

extension GameCell: Equatable {
    static func == (lhs: GameCell, rhs: GameCell) -> Bool {
        lhs.predefinedValue == rhs.predefinedValue && lhs._value == rhs._value
    }
}

extension GameCell {
    func hash(into hasher: inout Hasher) {
        hasher.combine(predefinedValue)
        hasher.combine(_value)
    }
}

extension Array where Element == GameCell {
    
    /// Returns array of GameCells which where reset to predefinedValue
    func cleared() -> Self {
        self.map { GameCell(predefinedValue: $0.predefinedValue) }
    }
}
