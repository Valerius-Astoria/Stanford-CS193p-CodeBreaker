//
//  GameSummary.swift
//  CodeBreaker2
//
//  Created by ZAKA on 10/16/26.
//

import SwiftUI

struct GameSummary: View {
    
    // MARK: - Data In
    var game: CodeBreaker
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading) {
            Text(game.name).font(.title)
            PegChooser(game: game, selection: .constant(0)).aspectRatio(contentMode: .fit)
            Text("^[\(game.attempts.count) attempt](inflect: true)")
        }
    }
}

#Preview {
    let game = CodeBreaker(name: "Test Game", numOfPegs: 4, colors: [.red, .green, .blue, .yellow])
    GameSummary(game: game)
}
