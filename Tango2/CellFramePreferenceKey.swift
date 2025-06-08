//
//  CellFramePreferenceKey.swift
//  Tango2
//
//  Created by Sergei Vasilenko on 9.06.2025.
//

import SwiftUI

struct CellFramePreferenceKey: PreferenceKey {
    typealias Value = [CellFramePreferenceKeyEntry]

    static var defaultValue: [CellFramePreferenceKeyEntry] = []

    static func reduce(value: inout [CellFramePreferenceKeyEntry],
                       nextValue: () -> [CellFramePreferenceKeyEntry])
    {
        value.append(contentsOf: nextValue())
    }
}

struct CellFramePreferenceKeyEntry: Hashable {
    let row: Int
    let column: Int
    let rect: CGRect
}
