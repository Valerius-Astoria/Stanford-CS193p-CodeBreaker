//
//  PegChooser.swift
//  CodeBreaker2
//
//  Created by ZAKA on 10/14/26.
//

import SwiftUI

struct PegChooser: View {
    
    // MARK: - Data In
    var game: CodeBreaker
    
    // MARK: - Data Shared with Me
    @Binding var selection: Int
    
    var body: some View {
        HStack {
            ForEach(game.pegChoices.indices, id: \.self) { index in
                Button {
                    game.guess.pegs[selection] = game.pegChoices[index]
                    selection = (selection + 1) % game.numOfPegs
                } label: {
                    Circle().foregroundStyle(game.pegChoices[index])
                }
            }
        }
    }
}

#Preview {
    @Previewable var game = CodeBreaker(name: "Test Game", numOfPegs: 4, pegChoices: [.red, .green, .blue, .yellow])
    @Previewable @State var selection = 0
    PegChooser(game: game, selection: $selection)
}
