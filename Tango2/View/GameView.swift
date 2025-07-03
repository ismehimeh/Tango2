//
//  GameView.swift
//  Tango2
//
//  Created by Sergei Vasilenko on 9.06.2025.
//

import SwiftUI

struct GameView: View {
    @Environment(\.undoManager) var undoManager
        
    @State private var showingSettings = false
    @State private var showingResult = false
    @State private var showingClearAlert = false
    @AppStorage(GameSettings.clockVisibleKey) private var isClockVisible = GameSettings.defaultClockVisible
    @State private var viewModel = GameViewModel()
    @AppStorage(GameSettings.mistakeHighlightKey) private var isMistakeVisible = GameSettings.defaultMistakeHighlight
    @AppStorage(GameSettings.redoVisibilityKey) private var isRedoVisible = GameSettings.defaultRedoVisibility
    @State private var showMistake = false
    @State var mistakeValidationID: UUID?
    @State private var isControlsDisabled = false
    
    private let winningDelay = 2
    
    var game: Game
    
    // MARK: - Views
    var body: some View {
        ScrollView {
            VStack {
                topView
                GameFieldView(game: game, showMistake: $showMistake, showSolved: $showingResult)
                undoAndHintView
                mistakesListView
                HowToPlayView()
                    .frame(width: 300)
            }
            .padding(.horizontal, 15)
        }
        .toolbar {
            Button {
                showingSettings = true
            } label: {
                Image(systemName: "gearshape.fill")
            }
        }
        .navigationBarBackButtonHidden(isControlsDisabled)
        .disabled(isControlsDisabled)
        .onAppear {
            game.setUndoManager(undoManager)
            viewModel.secondsPassed = game.secondsSpent
            viewModel.startTimer()
        }
        .onDisappear {
            game.secondsSpent = viewModel.secondsPassed
            viewModel.startTimer()
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView()
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $showingResult) {
            ResultView()
        }
        .alert("You sure?", isPresented: $showingClearAlert) {
            Button("Yes", role: .destructive) {
                game.clearField()
            }
            Button("No", role: .cancel) { }
        }
        .onChange(of: game.isSolved, initial: false) { _, newValue in
            viewModel.stopStimer()
            isControlsDisabled = true
            
            // run glimmer animations
            // scale a littble bit every cell?
            // show result screen after everything happend
            
            if newValue {
                Task {
                    try? await Task.sleep(for: .seconds(winningDelay))
                    await MainActor.run {
                        showingResult = true
                    }
                }
            }
            else {
                showingResult = newValue
            }
        }
        .onChange(of: game.isMistake, initial: true) { _, newValue in
            processMistake(newValue)
        }
    }

    var topView: some View {
        HStack {
            if isClockVisible {
                Image(systemName: "clock")
                Text(viewModel.timeString)
            }
            Spacer()
            Button {
                showingClearAlert = true
            } label: {
                Text("Clear")
                    .padding(.horizontal, 5)
            }
            .buttonStyle(.bordered)
            .buttonBorderShape(.capsule)
        }
    }

    var undoAndHintView: some View {
        HStack {
            
            VStack {
                Button {
                    undoManager?.undo()
                } label: {
                    Text("Undo")
                        .frame(maxWidth: .infinity)
                }
                .disabled(!(undoManager?.canUndo ?? false))
                
                if isRedoVisible {
                    Button {
                        undoManager?.redo()
                    } label: {
                        Text("Redo")
                            .frame(maxWidth: .infinity)
                    }
                    .disabled(!(undoManager?.canRedo ?? false))
                }
            }
            .buttonStyle(.bordered)
            .buttonBorderShape(.capsule)

            Button {
                print("Hint!")
            } label: {
                Text("Hint")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .buttonBorderShape(.capsule)
        }
    }
    
    var mistakesListView: some View {
        ForEach(game.mistakes, id: \.self) { mistake in
            HStack {
                Text(mistake.type.description)
                    .multilineTextAlignment(.leading)
                Spacer()
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(.red)
            )
        }
    }
    
    private func processMistake(_ newValue: Bool) {
        if newValue {
            let mistakeId = UUID()
            mistakeValidationID = mistakeId
            Task {
                try await Task.sleep(for: .milliseconds(300))
                validateMistake(mistakeId)
            }
        }
        else {
            showMistake = false
        }
    }
    
    @MainActor
    private func validateMistake(_ id: UUID) {
        guard id == mistakeValidationID else { return }
        showMistake = game.isMistake && isMistakeVisible
    }
}

#Preview {
    @Previewable @State var game = Game(level1)
    GameView(game: game)
}

//#Preview("Mistakes") {
//    @Previewable @State var game = Game(mistakesTestLevel)
//    GameView(game: game)
//}
