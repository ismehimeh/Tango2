//
//  LevelCell.swift
//  Tango2
//
//  Created by Sergei Vasilenko on 16.07.2025.
//

import Foundation
import SwiftData

@Model
class LevelCell: Hashable, Equatable {
    var predefinedValueRaw: Int?
    
    var predefinedValue: CellValue? {
        get {
            guard let raw = predefinedValueRaw else { return nil }
            return CellValue(rawValue: raw)
        }
        set {
            predefinedValueRaw = newValue?.rawValue
        }
    }
    
    init(predefinedValue: CellValue? = nil) {
        self.predefinedValueRaw = predefinedValue?.rawValue
    }
}
