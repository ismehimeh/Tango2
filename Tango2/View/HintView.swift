//
//  HintsView.swift
//  Tango2
//
//  Created by Sergei Vasilenko on 14.07.2025.
//

import SwiftUI

struct HintView: View {
    
    var description: String
    @Binding var shakes: Int
    
    var dismissHintTapped: () -> Void
    var showMeTapped: () -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Hint:")
                    .bold()
                Spacer()
                Button {
                    dismissHintTapped()
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
            
            Button {
                showMeTapped()
            } label: {
                Text("Show Me").bold().font(.footnote)
            }
            .foregroundStyle(.black)
            .buttonStyle(.bordered)
            .padding(.top, 10)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 4)
                .stroke(.gray.opacity(0.3))
        )
        .modifier(Shake(animatableData: CGFloat(shakes)))
    }
}

#Preview {
    HintView(description: "This is description", shakes: .constant(0)) { } showMeTapped: {}
}

