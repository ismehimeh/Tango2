//
//  ResultsView.swift
//  Tango2
//
//  Created by Sergei Vasilenko on 9.06.2025.
//

import SwiftUI

struct ResultView: View {

    @Environment(\.dismiss) var dismiss
    @Environment(Router.self) var router
    @Environment(AppState.self) var state

    var gameResult: GameResult
    var showButtons: Bool = true

    var body: some View {
        VStack {

            Text("You're crushing it!")
                .font(.largeTitle)
                .bold()
                .padding(.bottom, 40)
                .padding(.top, 50)

            VStack {
                Text(gameResult.solvedLevel.title)
                    .font(.largeTitle)
                    .bold()
                Text("\(gameResult.secondsSpent)")
                    .font(.title3)
                    .fontWeight(.medium)
            }
            .padding(30)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))

            if showButtons {
                if state.isNextLevelAvailable {
                    Button {
                        tapNextLevel()
                    } label: {
                        HStack {
                            Text("Next Level")
                            Image(systemName: "chevron.forward.2")
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(.top, 40)
                }
                else {
                    Text("You solved all levels!")
                        .font(.title2)
                        .foregroundStyle(.white)
                }

                Button {
                    tapGoToLevels()
                } label: {
                    Text("Go to levels")
                        .foregroundStyle(.white)
                }
            }

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.gray)
    }

    private func tapNextLevel() {
        if state.moveToNextLevel() {
            dismiss()
            router.path.removeLast()
            let nextLevel = state.currentLevel
            router.open(nextLevel)
        }
        else {
            print("This is last level!")
        }
    }

    private func tapGoToLevels() {
        dismiss()
        router.path.removeLast()
    }
}

#Preview {
    @Previewable @State var appState = AppState()
    let result = GameResult(solvedLevel: level1, secondsSpent: 120, hintsUsed: 3, undosUsed: 4)
    appState.setCurrentLevel(0)
    return ResultView(gameResult: result)
        .environment(Router(path: .init()))
        .environment(appState)
}

#Preview("No next levels") {
    @Previewable @State var appState = AppState()
    let result = GameResult(solvedLevel: level1, secondsSpent: 120, hintsUsed: 3, undosUsed: 4)
    appState.setCurrentLevel(2)
    return ResultView(gameResult: result)
        .environment(Router(path: .init()))
        .environment(appState)
}
