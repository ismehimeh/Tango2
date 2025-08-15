//
//  Mistake.swift
//  Tango2
//
//  Created by Sergei Vasilenko on 28.06.2025.
//

struct Mistake: Equatable, Hashable {
    let cells: [CellPosition]
    let type: MistakeType
}

enum MistakeType: Hashable {
    case noMoreThan2
    case signViolation(Condition.Sign)
    case sameNumberValues
}

extension MistakeType {
    
    var description: String {
        switch self {
        case .noMoreThan2:
            return "No more than 2 \(zeroSymbol) and \(oneSymbol) may be next to each other, either vertically or horizontally"
        case .signViolation(let condition):
            switch condition {
            case .equal:
                return "Cells separated by an \(Condition.Sign.equal.symbol) sign must be of the same type"
            case .opposite:
                return "Cell separated by \(Condition.Sign.opposite.symbol) sign must be of the opposite type"
            }
        case .sameNumberValues:
            return "Each row (and column) must contain the same number of \(zeroSymbol) and \(oneSymbol)"
        }
    }
    
    var tutorialDescription: String {
        switch self {
        case .signViolation(let condition):
            switch condition {
            case .equal:
                return "Use identical shapes to join cells with a \(Condition.Sign.equal.symbol)."
            case .opposite:
                return "Use opposite shapes to separate cells with \(Condition.Sign.opposite.symbol)."
            }
        case .noMoreThan2:
            return "Oops! Only 2 \(zeroSymbol) and \(oneSymbol) can touch, either vertically or horizontally."
        case .sameNumberValues:
            return "Each row and column must have the same number of \(zeroSymbol) and \(oneSymbol)."
        }
    }
}
