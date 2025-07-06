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
    
    var levelTitle: String
    var timeSpent: String
    
    var body: some View {
        VStack {
            
            Text("You're crushing it!")
                .font(.largeTitle)
                .bold()
                .padding(.bottom, 40)
                .padding(.top, 50)
            
            VStack {
                Text(levelTitle)
                    .font(.largeTitle)
                    .bold()
                Text(timeSpent)
                    .font(.title3)
                    .fontWeight(.medium)
            }
            .padding(30)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            
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

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.secondary)
        .navigationBarBackButtonHidden()
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
        // TODO: implement
    }
}

#Preview {
    @Previewable @State var appState = AppState()
    appState.setCurrentLevel(0)
    return ResultView(levelTitle: "23", timeSpent: "1:20")
        .environment(Router(path: .init()))
        .environment(appState)
}

#Preview("No next levels") {
    @Previewable @State var appState = AppState()
    appState.setCurrentLevel(2)
    return ResultView(levelTitle: "23", timeSpent: "1:20")
        .environment(Router(path: .init()))
        .environment(appState)
}
