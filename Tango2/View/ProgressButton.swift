//
//  ProgressButton.swift
//  Tango2
//
//  Created by Sergei Vasilenko on 14.07.2025.
//

import SwiftUI

struct ProgressButton: View {
    @State private var progress: CGFloat = 0
    var duration: TimeInterval
    var action: (Bool) -> Void
    var body: some View {
        Button {

        } label: {
            Text("Hint")
                .padding(.horizontal, 40)
        }
        .buttonStyle(.bordered)
        .overlay {
            Capsule()
                .foregroundStyle(.gray.opacity(0.3))
                .mask {
                    ZStack {
                        HStack{
                            Rectangle()
                                .blendMode(.destinationOver)
                                .scaleEffect(x: progress, anchor: .leading)
                        }
                    }
                }
        }
        .onTapGesture {
            action(progress != 0)
            guard progress == 0 else { return }
            withAnimation(.linear(duration: duration)) {
                progress = 1
            } completion: {
                progress = 0
            }
        }
    }
}

#Preview {
    ProgressButton(duration: 5) { _ in }
}
