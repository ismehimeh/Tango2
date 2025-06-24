//
//  GameCell.swift
//  Tango
//
//  Created by Sergei Vasilenko on 11.03.2025.
//

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

struct GameCell: Hashable {
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
