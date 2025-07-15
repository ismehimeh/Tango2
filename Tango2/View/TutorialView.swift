//
//  TutorialView.swift
//  Tango2
//
//  Created by Sergei Vasilenko on 15.07.2025.
//

import SwiftUI

struct TutorialView: View {
    private let buttonColor = Color(red: 55/255.0, green: 110/255.0, blue: 191/255.0)
    
    var body: some View {
        descriptionView
            .padding(.horizontal, 60)
    }
    
    var descriptionView: some View {
        VStack {
            VStack(alignment: .leading) {
                Text("The goal of the puzzle is to fill the grid with \(CellValue.zero.symbol) and \(CellValue.one.symbol).\n\nPlay quick tutorial to learn the rules.")
                    .padding(.bottom, 20)
                
                Button {
                    
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
            .padding(.horizontal, 20)
            .padding(.vertical, 15)
        }
        .background(
            RoundedRectangle(cornerRadius: 5)
                .stroke(.gray.opacity(0.3))
                .fill(.gray.opacity(0.1))
        )
    }
}

#Preview {
    TutorialView()
}
