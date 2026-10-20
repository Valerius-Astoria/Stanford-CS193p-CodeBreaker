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

    // MARK: - Body
    var body: some View {
        HStack {
            ForEach(game.pegChoices, id: \.self) { peg in
                Button {
                    game.setGuessPeg(peg, at: selection)
                    selection = (selection + 1) % game.numOfPegs
                } label: {
                    PegView(peg: peg)
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var game = CodeBreaker(name: "Test Game", numOfPegs: 4,
                                               colors: [.red, .green, .blue, .yellow])
    @Previewable @State var selection = 0
    PegChooser(game: game, selection: $selection)
}
