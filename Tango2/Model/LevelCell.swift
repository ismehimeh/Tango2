//
//  LevelCell.swift
//  Tango2
//
//  Created by Sergei Vasilenko on 16.07.2025.
//

import Foundation
import SwiftData

/// Immutable representation of a cell in a level definition
@Model
class LevelCell: Hashable, Equatable, Codable {
    var predefinedValue: CellValue?

    init(predefinedValue: CellValue? = nil) {
        self.predefinedValue = predefinedValue
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(predefinedValue)
    }

    static func == (lhs: LevelCell, rhs: LevelCell) -> Bool {
        lhs.predefinedValue == rhs.predefinedValue
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        predefinedValue = try container.decodeIfPresent(CellValue.self, forKey: .predefinedValue)
    }

    enum CodingKeys: String, CodingKey {
        case predefinedValue
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(predefinedValue, forKey: .predefinedValue)
    }
}
