//
//  UndoManagerProtocol.swift
//  Tango2
//
//  Created by Sergei Vasilenko on 10.08.2025.
//

import Foundation

protocol UndoManagerProtocol {
    func registerUndo<TargetType>(
        withTarget target: TargetType,
        handler: @escaping @MainActor (TargetType) -> Void
    ) where TargetType: AnyObject
}

extension UndoManager: UndoManagerProtocol { }
