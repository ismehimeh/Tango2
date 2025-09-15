//
//  TutorialStage.swift
//  Tango2
//
//  Created by Sergei Vasilenko on 19.07.2025.
//


enum TutorialStage: CaseIterable {
    case intro
    case noMoreThan2First
    case sameNumber
    case equalSign
    case oppositeSign
    case noMoreThan2Second
    case doItYourself
    case congrats
    
    var next: TutorialStage? {
        let allCases = TutorialStage.allCases
        guard let currentIndex = allCases.firstIndex(of: self),
              currentIndex < allCases.count - 1 else {
            return nil
        }
        return allCases[currentIndex + 1]
    }
    
    var highligthedCell: CellPosition? {
        switch self {
        case .noMoreThan2First:
            return .init(row: 1, column: 2)
        case .sameNumber:
            return .init(row: 1, column: 0)
        case .equalSign:
            return .init(row: 0, column: 0)
        case .oppositeSign:
            return .init(row: 0, column: 1)
        case .noMoreThan2Second:
            return .init(row: 2, column: 1)
        default:
            return nil
        }
    }
    
    var notDimmedCells: [CellPosition]? {
        switch self {
        case .noMoreThan2First:
            return [
                .init(row: 1, column: 1),
                .init(row: 1, column: 3)
            ]
        case .sameNumber:
            return [
                .init(row: 1, column: 1),
                .init(row: 1, column: 2),
                .init(row: 1, column: 3)
            ]
        case .equalSign:
            return [
                .init(row: 1, column: 0)
            ]
        case .oppositeSign:
            return [
                .init(row: 0, column: 0)
            ]
        case .noMoreThan2Second:
            return [
                .init(row: 0, column: 1),
                .init(row: 1, column: 1)
            ]
        default:
            return nil
        }
    }
    
    var expectedCellValue: CellValue? {
        switch self {
        case .noMoreThan2First, .sameNumber, .equalSign, .noMoreThan2Second:
            return .zero
        case .oppositeSign:
            return .one
        default:
            return nil
        }
    }
    
    var text: String {
        switch self {
        case .intro:
            return "The goal of the puzzle is to fill the grid with \(CellValue.zero.symbol) and \(CellValue.one.symbol).\n\nPlay quick tutorial to learn the rules."
        case .noMoreThan2First:
            return "\(HintType.noMoreThan2(value: .zero).description)\n\nPlace a \(CellValue.zero.symbol) by tapping on the highlighted cell."
        case .sameNumber:
            return "Each row (and column) must contain the same number of \(CellValue.zero.symbol) and \(CellValue.one.symbol).\n\nTherefore, the highlighted cell must be a \(CellValue.zero.symbol)."
        case .equalSign:
            return HintType.sign(sign: Condition.Sign.equal.symbol, value: .zero).description
        case .oppositeSign:
            return "\(HintType.sign(sign: Condition.Sign.opposite.symbol, value: .one).description)\n\nPlace a \(CellValue.one.symbol) by tapping twice on the highlighted cell."
        case .noMoreThan2Second:
            return HintType.noMoreThan2(value: .one).description
        case .doItYourself:
            return "Each puzzle has one right answer and can be solved via deduction (you should never have to make a guess).\n\nYou now know everything you need to complete the puzzle.\n\nGood luck!"
        case .congrats:
            return "Congrats on finishing the tutorial.\nYou're ready to play!"
        }
    }
}
