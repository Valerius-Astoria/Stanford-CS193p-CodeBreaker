//
//  PegChoicesChooser.swift
//  CodeBreaker2
//
//  Created by ZAKA on 10/18/26.
//

import SwiftUI

struct PegChoicesChooser: View {
    
    // MARK: - Data Shared with Me
    @Binding var pegChoices: [Peg]
    
    var body: some View {
        List {
            ForEach(pegChoices.indices, id: \.self) { index in
                ColorPicker(selection: $pegChoices[index], supportsOpacity: false) {
                    button("Peg Choice \(index + 1)", systemImage: "minus.circle", color: .red) {
                        pegChoices.remove(at: index)
                    }
                }
            }
            // Add a new peg choice.
            button("Add", systemImage: "plus.circle", color: .green) {
                pegChoices.append(.green)
            }
        }
    }
    
    // Customized button with image and title appears on the same row.
    func button(
        _ title: String, // No argument name for this property.
        systemImage: String,
        color: Color? = nil, // optional
        action: @escaping () -> Void
    ) -> some View {
        HStack {
            Button {
                action()
            } label: {
                Image(systemName: systemImage).tint(color)
            }
            Text(title)
        }
    }
}

#Preview {
    @Bindable var game = CodeBreaker(name: "Test Game", numOfPegs: 4, pegChoices: [.red, .green, .blue, .yellow])
    PegChoicesChooser(pegChoices: $game.pegChoices)
}
