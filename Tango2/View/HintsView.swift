//
//  HintsView.swift
//  Tango2
//
//  Created by Sergei Vasilenko on 14.07.2025.
//

import SwiftUI

struct HintsView: View {
    
    var description: String
    @Binding var shakes: Int
    
    var dismissHintTapped: (() -> Void)?
    
    var body: some View {
        VStack {
            HStack {
                Text("Hint:")
                    .bold()
                Spacer()
                Button {
                    dismissHintTapped?()
                } label: {
                    Image(systemName: "xmark")
                        .resizable()
                        .aspectRatio(1, contentMode: .fit)
                        .frame(width: 10)
                        .foregroundStyle(.black)
                        .padding(10)
                }
            }
            .padding(.bottom, 5)
            HStack {
                Text(description)
                    .multilineTextAlignment(.leading)
                Spacer()
            }
            
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 4)
                .stroke(.red.opacity(0.2))
        )
        .modifier(Shake(animatableData: CGFloat(shakes)))
    }
}

