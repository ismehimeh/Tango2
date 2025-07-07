//
//  Hint.swift
//  Tango2
//
//  Created by Sergei Vasilenko on 7.07.2025.
//

enum Hint {
    case incorrectCell
    case oneOptionLeft(lineName: String, option: String)
    case forcedThreeWithSameNumber(lineName: String, wrongOption: String, option: String)
    case forcedThreeNoMoreThan2(wrongOption: String, option: String, sign: String)
    case sign(sign: String, option: String)
    case noMoreThan2(option: String)
    
    var description: String {
        switch self {
        case .incorrectCell:
            return "The highlighted cell is incorrect"
        case let .oneOptionLeft(lineName: lineName, option: option):
            return "Each \(lineName) must contain the same number of \(zeroSymbol) and \(oneSymbol).\nThis leaves only one option for the highlighted cell in this \(lineName). Therefore the highlighted cell must be a \(option)."
        case let .forcedThreeWithSameNumber(lineName: lineName, wrongOption: wrongOption, option: option):
            return "Each \(lineName) must contain the same number of \(zeroSymbol) and \(oneSymbol).\nPlacing a \(wrongOption) in the highlighted cell would force three \(option) to be placed together.\nTherefore the highlighted cell must be a \(option)."
        case let .forcedThreeNoMoreThan2(wrongOption: wrongOption, option: option, sign: sign):
            return "No more than 2 \(zeroSymbol) or \(oneSymbol) may be next to each other, either vertically or horizontally.\n\nPlacing a \(wrongOption) in the highlighted cell would force three \(option) to be placed in this row due to the \(sign).\n\nTherefore the highlighted cell must be a \(option)."
        case let .sign(sign: sign, option: option):
            return "Cells separated by an \(sign) sign must be of the same type.\nTherefore the highlighted cell must be a \(option)."
        case let .noMoreThan2(option: option):
            return "No more than 2 \(zeroSymbol) or \(oneSymbol) may be next to each other, either vertically or horizontally.\nTherefore the highlighted cell must be a \(option)."
        }
    }
}
