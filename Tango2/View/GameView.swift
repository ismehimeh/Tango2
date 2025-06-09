//
//  GameView.swift
//  Tango2
//
//  Created by Sergei Vasilenko on 9.06.2025.
//

import SwiftUI

struct GameView: View {
    
    @State var viewModel: GameViewModel

    // MARK: - Views
    var body: some View {
        ScrollView {
            VStack {
                topView
                GameFieldView(viewModel: viewModel.gameFieldViewModel)
                undoAndHintView
                HowToPlayView()
                    .frame(width: 300)
            }
            .padding(.horizontal, 15)
        }
        .toolbar {
            Button {
                viewModel.tapSettings()
            } label: {
                Image(systemName: "gearshape.fill")
            }
        }
        .onAppear {
            viewModel.startTimer()
        }
        .sheet(isPresented: $viewModel.showingSettings) {
            SettingsView(viewModel: .init())
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $viewModel.showingResult) {
            ResultView(viewModel: .init())
        }
        .alert("You sure?", isPresented: $viewModel.showingClearAlert) {
            Button("Yes", role: .destructive) {
                viewModel.confirmClear()
            }
            Button("No", role: .cancel) { }
        }
        .onChange(of: viewModel.gameFieldViewModel.isSolved, initial: false) { _, newValue in
            viewModel.showingResult = newValue
        }
    }

    var topView: some View {
        HStack {
            if viewModel.isClockVisible {
                Image(systemName: "clock")
                Text(viewModel.timeString)
            }
            Spacer()
            Button {
                viewModel.tapClear()
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
}

#Preview {
    GameView(viewModel: .init(.init(level1)))
}
