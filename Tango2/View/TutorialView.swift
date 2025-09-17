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
    @Environment(\.dismiss) var dismiss
    var body: some View {
        ScrollView {
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
                    .allowsHitTesting(stage != .congrats)
                    if stage == .intro {
                        // covers field in `invisible` tappable area
                        Color.white.opacity(0.0001)
                            .onTapGesture {
                                nextStage()
                            }
                    }
                }
                .aspectRatio(1, contentMode: .fit)
                .onChange(of: game.isSolved, initial: false) { _, newValue in
                    if newValue {
                        nextStage()
                    }
                }

                MistakesListView(mistakes: game.mistakes.map({$0.type.tutorialDescription}))

                informationView

                if stage == .doItYourself {
                    HowToPlayView(title: "Reminder of how to play")
                        .padding(.horizontal, 20)
                        .padding(.vertical, 15)
                        .background(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(.gray.opacity(0.3))
                                .fill(.gray.opacity(0.1))
                        )
                }
            }
            .padding(.horizontal, 60)
        }
        Spacer()
    }

    private var informationView: some View {
        VStack {
            VStack(alignment: .leading) {
                Text(stage.text)
                    .padding(.bottom, 20)
                supplementViewForStage
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 15)
        }
        .background(
            RoundedRectangle(cornerRadius: 5)
                .stroke(.gray.opacity(0.3))
                .fill(.gray.opacity(0.1))
        )
    }

    @ViewBuilder
    private var supplementViewForStage: some View {
        switch stage {
        case .intro:
            playTutorialButton
        case .congrats:
            playGameButton
        default:
            EmptyView()
        }
    }

    private var playTutorialButton: some View {
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

    private var playGameButton: some View {
        Button {
            dismiss()
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

    private func nextStage() {
        if let next = stage.next {
            stage = next
        }
    }
}

#Preview {
    TutorialView()
}
