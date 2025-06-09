//
//  ResultsView.swift
//  Tango2
//
//  Created by Sergei Vasilenko on 9.06.2025.
//

import SwiftUI

struct ResultView: View {

    @State var viewModel = ResultViewModel()
    
    var body: some View {
        VStack {
            Button {
                viewModel.tapNextLevel()
            } label: {
                Text("Play next levels")
            }

            Button {
                viewModel.tapGoToLevels()
            } label: {
                Text("Main Page")
            }

            Button {
                viewModel.tapPop()
            } label: {
                Text("TEMP: Just pop it")
            }
        }
        .navigationBarBackButtonHidden()
    }
}
