//
//  Hint.swift
//  Tango2
//
//  Created by Sergei Vasilenko on 7.07.2025.
//

enum HintType: Equatable {
    case incorrectCell(value: CellValue)
    case oneOptionLeft(lineName: String, value: CellValue)
    case forcedThreeWithSameNumber(lineName: String, value: CellValue)
    case forcedThreeNoMoreThan2(value: CellValue, sign: String)
    case sign(sign: String, value: CellValue)
    case noMoreThan2(value: CellValue)
    case tripleOpposite(lineName: String, value: CellValue)
    
    var description: String {
        switch self {
        case .incorrectCell:
            return "The highlighted cell is incorrect"
        case let .oneOptionLeft(lineName, value):
            return "Each \(lineName) must contain the same number of \(zeroSymbol) and \(oneSymbol).\n\nThis leaves only one option for the highlighted cell in this \(lineName).\n\nTherefore the highlighted cell must be a \(value.symbol)."
        case let .forcedThreeWithSameNumber(lineName, value):
            return "Each \(lineName) must contain the same number of \(zeroSymbol) and \(oneSymbol).\n\nPlacing a \(value.opposite.symbol) in the highlighted cell would force three \(value.symbol) to be placed together.\n\nTherefore the highlighted cell must be a \(value.symbol)."
        case let .forcedThreeNoMoreThan2(value, sign):
            return "No more than 2 \(zeroSymbol) or \(oneSymbol) may be next to each other, either vertically or horizontally.\n\nPlacing a \(value.symbol) in the highlighted cell would force three \(value.symbol) to be placed in this row due to the \(sign).\n\nTherefore the highlighted cell must be a \(value.symbol)."
        case let .sign(sign, value):
            return "Cells separated by an \(sign) sign must be of the same type.\n\nTherefore the highlighted cell must be a \(value.symbol)."
        case let .noMoreThan2(value):
            return "No more than 2 \(zeroSymbol) or \(oneSymbol) may be next to each other, either vertically or horizontally.\n\nTherefore the highlighted cell must be a \(value.symbol)."
        case let .tripleOpposite(lineName, value):
            // N=NN010 - tripple opposite? Yes, exactly
            // TODO: then we need other naming
            // I consider it special case, because saw it only once
            //NxNxN101
            //NxNxN010
            // All other variations should be already covered with other hints
            return "Each \(lineName) must contain the same number of \(zeroSymbol) and \(oneSymbol)./n/nThe final \(value.symbol) in this \(lineName) must be elsewhere due to the remaining \(GameCellCondition.Condition.opposite.symbol).\n\nTherefore the highlighted cell must be a \(value.symbol)."
        }
    }
}


/// A structure representing a hint in the game that provides guidance to the player.
struct Hint: Equatable {
    /// The type of hint, describing the rule being applied
    let type: HintType
    
    /// The position of the cell that the hint is targeting
    let targetCell: CellPosition
    
    /// An array of related cell positions that are relevant to this hint
    let relatedCells: [CellPosition]
    
    init(type: HintType, targetCell: CellPosition, relatedCells: [CellPosition] = []) {
        self.type = type
        self.targetCell = targetCell
        self.relatedCells = relatedCells
    }
}
