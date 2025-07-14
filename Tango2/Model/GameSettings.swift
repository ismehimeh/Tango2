//
//  GameSettings.swift
//  Tango2
//
//  Created by Sergei Vasilenko on 22.06.2025.
//

import Foundation

enum GameSettings {
    // Keys
    static let clockVisibleKey = "isClockVisible"
    static let mistakeHighlightKey = "isMistakeHighlightEnabled"
    static let redoVisibilityKey = "isRedoVisible"
    static let hintDelayKey = "hintDelay"
    
    // Default values
    static let defaultClockVisible = true
    static let defaultMistakeHighlight = true
    static let defaultRedoVisibility = false
    static let defaultHintDelay = 10.0
    
    // Register defaults on app launch
    static func registerDefaults() {
        UserDefaults.standard.register(defaults: [
            clockVisibleKey: defaultClockVisible,
            mistakeHighlightKey: defaultMistakeHighlight,
            redoVisibilityKey: defaultRedoVisibility,
            hintDelayKey: defaultHintDelay
        ])
    }
}
