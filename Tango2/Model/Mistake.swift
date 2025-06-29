//
//  Mistake.swift
//  Tango2
//
//  Created by Sergei Vasilenko on 28.06.2025.
//

enum MistakeType {

    case noMoreThan2
    case signViolation(GameCellCondition.Condition)
    case sameNumberValues
}

extension MistakeType {
    
    var description: String {
        switch self {
        case .noMoreThan2:
            return "No more than 2 🌞 and 🌚 may be next to each other, either vertically or horizontally"
        case .signViolation(let condition):
            switch condition {
            case .equal:
                return "Cells separated by an = sign must be of the same type"
            case .opposite:
                return "Cell separated by X sign must be of the opposite type"
            }
        case .sameNumberValues:
            return "Each row (and column) must contain the same number of 🌞 and 🌚"
        }
    }
}
