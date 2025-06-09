//
//  HowToPlayView.swift
//  Tango2
//
//  Created by Sergei Vasilenko on 9.06.2025.
//

import SwiftUI

struct HowToPlayView: View {
    var body: some View {
        DisclosureGroup("How to play") {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("•")
                    Text(
                        "Fill the grid so that each cell contains either a 🌞 or a 🌚."
                    )
                }

                HStack {
                    Text("•")
                    Text(
                        "No more than 2 🌞 or 🌚 may be next to each other, either vertically or horizontally."
                    )
                }

                HStack {
                    Text("•")
                    Text("🌞🌞✅")
                }
                .padding(.leading, 20)

                HStack {
                    Text("•")
                    Text("🌞🌞🌞❌")
                }
                .padding(.leading, 20)

                HStack {
                    Text("•")
                    Text(
                        "Each row (and column) must contain the same number of 🌞 and 🌚 ."
                    )
                }

                HStack {
                    Text("•")
                    Text(
                        "Cells separated by an **=** sign must be of the same type."
                    )
                }

                HStack {
                    Text("•")
                    Text(
                        "Cells separated by an **X** sign must be of the opposite type."
                    )
                }

                HStack {
                    Text("•")
                    Text(
                        "Each puzzle has one right answer and can be solved via deduction (you should never have to make a guess)."
                    )
                }
            }
        }
    }
}

#Preview {
    HowToPlayView()
}
