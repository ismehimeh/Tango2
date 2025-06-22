//
//  GameView.swift
//  Tango2
//
//  Created by Sergei Vasilenko on 9.06.2025.
//

import SwiftUI

struct GameView: View {
        
    @State private var showingSettings = false
    @State private var showingResult = false
    @State private var showingClearAlert = false
    @State private var isClockVisible = true
    @State private var viewModel = GameViewModel()
    @State private var isMistakeVisible = true
    @State private var showMistake = false
    @State var mistakeValidationID: UUID?
    
    @Binding var game: Game
    
    // MARK: - Views
    var body: some View {
        ScrollView {
            VStack {
                topView
                GameFieldView(game: $game, showMistake: $showMistake, showSolved: $showingResult)
                undoAndHintView
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
        .onAppear {
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
            showingResult = newValue
        }
        .onChange(of: game.isMistake, initial: false) { _, newValue in
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
            Button {
                print("Undo!")
            } label: {
                Text("Undo")
                    .frame(maxWidth: .infinity)
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
    GameView(game: $game)
}
