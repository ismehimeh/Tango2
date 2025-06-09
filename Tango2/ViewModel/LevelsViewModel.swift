//
//  LevelsViewModel.swift
//  Tango2
//
//  Created by Sergei Vasilenko on 9.06.2025.
//

import SwiftUI

@Observable
class LevelsViewModel {
    var levels: [Level]
    
    init(levels: [Level]) {
        self.levels = levels
    }
}
