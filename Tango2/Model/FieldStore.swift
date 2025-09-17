//
//  CellsManager.swift
//  Tango2
//
//  Created by Sergei Vasilenko on 10.08.2025.
//

import Combine
import SwiftUI

/// Stores field cells and provides fucntions to iteract with them
class FieldStore {
    var cells: [GameCell]
    var lineLength: Int
    private var undoManager: UndoManagerProtocol?

    private var fieldChangedSubject = PassthroughSubject<Void, Never>()
    var fieldNeedsRevalidation: AnyPublisher<Void, Never> {
        fieldChangedSubject.eraseToAnyPublisher()
    }

    init(_ cells: [GameCell],
         lineLength: Int,
         undoManager: UndoManagerProtocol? = nil)
    {
        self.cells = cells
        self.lineLength = lineLength
        self.undoManager = undoManager
    }

    func setUndoManager(_ undoManager: UndoManagerProtocol?) {
        self.undoManager = undoManager
    }

    /// Returns index of a cell from 1D field representation
    private func cellIndex(row: Int, column: Int) -> Int {
        return row * lineLength + column
    }

    func toggleCell(_ row: Int, _ column: Int) {
        let index = cellIndex(row: row, column: column)
        let cell = cells[index]
        guard cell.predefinedValue == nil else { return }

        let oldValue = cell.value

        undoManager?.registerUndo(withTarget: self) { [weak self] target in
            guard let self else { return }

            target.setCellValue(at: row, column: column, value: oldValue)

            undoManager?.registerUndo(withTarget: target) { _ in
                target.toggleCell(row, column)
            }
        }

        if cell.value == nil {
            cells[index].value = .zero
        }
        else if cell.value == .zero {
            cells[index].value = .one
        }
        else {
            cells[index].value = nil
        }

        fieldChangedSubject.send()
    }

    func setCellValue(at row: Int, column: Int, value: CellValue?) {
        let index = cellIndex(row: row, column: column)
        cells[index].value = value
        fieldChangedSubject.send()
    }

    func clearField() {
        let oldCells = cells

        undoManager?.registerUndo(withTarget: self) { [weak self] _ in
            guard let self else { return }

            resetField(with: oldCells)

            undoManager?.registerUndo(withTarget: self) { redoTarget in
                redoTarget.clearField()
            }
        }

        resetField(with: cells.cleared())
    }

    func resetField(with cells: [GameCell]) {
        self.cells = cells
        fieldChangedSubject.send()
    }

    /// Returns array of cells which corresponds to row specified by rowIndex
    func row(_ rowIndex: Int) -> [GameCell] {
        let startIndex = rowIndex * lineLength
        return Array(cells[startIndex..<startIndex + lineLength])
    }

    /// Returns array of cells which corresponds to column specified by columnIndex
    func column(_ columnIndex: Int) -> [GameCell] {
        (0..<lineLength).map {
            cells[cellIndex(row: $0,
                            column: columnIndex)]
        }
    }

    func cell(at row: Int, column: Int) -> GameCell {
        cells[cellIndex(row: row, column: column)]
    }
}
