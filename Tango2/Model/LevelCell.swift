//
//  LevelCell.swift
//  Tango2
//
//  Created by Sergei Vasilenko on 16.07.2025.
//

import Foundation

/// Immutable representation of a cell in a level definition
struct LevelCell: Hashable, Equatable {
    let predefinedValue: CellValue?
    
    init(predefinedValue: CellValue? = nil) {
        self.predefinedValue = predefinedValue
    }
}
