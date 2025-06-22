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
    
    var body: some View {
        VStack {
            Button {
                tapNextLevel()
            } label: {
                Text("Play next levels")
            }

            Button {
                tapGoToLevels()
            } label: {
                Text("Main Page")
            }

            Button {
                tapPop()
            } label: {
                Text("TEMP: Just pop it")
            }
        }
        .navigationBarBackButtonHidden()
    }
    
    private func tapNextLevel() {
        // TODO: implement
    }
    
    private func tapGoToLevels() {
        dismiss()
        router.path.removeLast()
    }
    
    private func tapPop() {
        dismiss()
    }
}
