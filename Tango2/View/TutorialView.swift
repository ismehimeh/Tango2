//
//  TutorialView.swift
//  Tango2
//
//  Created by Sergei Vasilenko on 15.07.2025.
//

import SwiftUI

struct TutorialView: View {

    private let buttonColor = Color(red: 55/255.0, green: 110/255.0, blue: 191/255.0)
    
    @State private var stage = TutorialStage.intro
    @State private var game = Game(tutorialLevel)
    
    var body: some View {
        // TODO: this should be a scroll because of expandable "Reminder how to play"
        VStack(spacing: 20) {
            ZStack {
                GameFieldView(game: game,
                              showMistake: .constant(false),
                              showSolved: .constant(false),
                              highlightedCell: stage.highligthedCell,
                              notDimmedCells: stage.notDimmedCells ?? [],
                              shakes: .constant(0))
                { value in
                    if value == stage.expectedCellValue {
                        nextStage()
                    }
                }
                if stage == .intro {
                    // covers field in `invisible` tappable area
                    Color.white.opacity(0.0001)
                        .onTapGesture {
                            nextStage()
                        }
                }
            }
            .aspectRatio(1, contentMode: .fit)
            // TODO: text changes width
            
            MistakesListView(mistakes: game.mistakes.map({$0.type.tutorialDescription}))
            
            VStack {
                VStack(alignment: .leading) {
                    Text(stage.text)
                        .padding(.bottom, 20)
                    supplementViewForStage
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 15)
                // TODO: "Reminder how to play" on the last slide
            }
            .background(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(.gray.opacity(0.3))
                    .fill(.gray.opacity(0.1))
            )
        }
        .padding(.horizontal, 60)
        Spacer()
    }
    
    @ViewBuilder
    var supplementViewForStage: some View {
        switch stage {
        case .intro:
            playTutorialButton
        case .doItYourself:
            HowToPlayView()
        case .congrats:
            playGameButton
        default:
            EmptyView()
            Button {
                if let next = stage.next {
                    stage = next
                }
            } label: {
                Text("Play tutorial") // or "Play game"
                    .bold()
                    .padding(.vertical, 7)
                    .frame(maxWidth: .infinity)
            }
            .foregroundStyle(buttonColor)
            .background(
                Capsule()
                    .stroke(buttonColor)
            )
        }
    }
    
    var playTutorialButton: some View {
        Button {
            nextStage()
        } label: {
            Text("Play tutorial")
                .bold()
                .padding(.vertical, 7)
                .frame(maxWidth: .infinity)
        }
        .foregroundStyle(buttonColor)
        .background(
            Capsule()
                .stroke(buttonColor)
        )
    }
    
    var playGameButton: some View {
        Button {
            nextStage()
        } label: {
            Text("Play game")
                .bold()
                .padding(.vertical, 7)
                .frame(maxWidth: .infinity)
        }
        .foregroundStyle(buttonColor)
        .background(
            Capsule()
                .stroke(buttonColor)
        )
    }
    
    func nextStage() {
        if let next = stage.next {
            stage = next
        }
    }
}

#Preview {
    TutorialView()
}

enum TutorialStage: CaseIterable {
    case intro
    case noMoreThan2
    case sameNumber
    case equalSign
    case oppositeSign
    case noMoreThan2_2
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
        case .noMoreThan2:
            return .init(row: 1, column: 2)
        case .sameNumber:
            return .init(row: 1, column: 0)
        case .equalSign:
            return .init(row: 0, column: 0)
        case .oppositeSign:
            return .init(row: 0, column: 1)
        case .noMoreThan2_2:
            return .init(row: 2, column: 1)
        default:
            return nil
        }
    }
    
    var notDimmedCells: [CellPosition]? {
        switch self {
        case .noMoreThan2:
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
        case .noMoreThan2_2:
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
        case .noMoreThan2, .sameNumber, .equalSign, .noMoreThan2_2:
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
        case .noMoreThan2:
            return "\(HintType.noMoreThan2(value: .zero).description)\n\nPlace a \(CellValue.zero.symbol) by tapping on the highlighted cell."
        case .sameNumber:
            return "Each row (and column) must contain the same number of \(CellValue.zero.symbol) and \(CellValue.one.symbol).\n\nTherefore, the highlighted cell must be a \(CellValue.zero.symbol)."
        case .equalSign:
            return HintType.sign(sign: GameCellCondition.Condition.equal.symbol, value: .zero).description
        case .oppositeSign:
            return "\(HintType.sign(sign: GameCellCondition.Condition.opposite.symbol, value: .one).description)\n\nPlace a \(CellValue.one.symbol) by tapping twice on the highlighted cell."
        case .noMoreThan2_2:
            return HintType.noMoreThan2(value: .one).description
        case .doItYourself:
            return "Each puzzle has one right answer and can be solved via deduction (you should never have to make a guess).\n\nYou now know everything you need to complete the puzzle.\n\nGood luck!"
        case .congrats:
            return "Congrats on finishing the tutorial.\nYou're ready to play!"
        }
    }
}
