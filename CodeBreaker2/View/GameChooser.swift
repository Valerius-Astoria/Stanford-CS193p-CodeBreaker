//
//  GameChooser.swift
//  CodeBreaker2
//
//  Created by ZAKA on 10/16/26.
//

import SwiftUI

struct GameChooser: View {
    
    // MARK: - Data Shared with Me
    @Binding var games: [CodeBreaker]
    
    // MARK: - Data Owned by Me
    @State private var selection: CodeBreaker.ID?
    
    // MARK: - Body
    var body: some View {
        NavigationSplitView {
            // Renders the list of available games.
            List($games, editActions: [.move, .delete]) { $game in // Allows the moving and deletion action on each list item.
                NavigationLink {
                    // Destination of the link
                    CodeBreakerView(game: game)
                        .navigationTitle(game.name)
                        .navigationBarTitleDisplayMode(.inline)
                } label: {
                    // Display of the link.
                     GameSummary(game: game)
                }
            }
            .toolbar {
                EditButton()
            }
            .navigationTitle("Code Breaker")
        } detail: { // Supports iPad and Mac by identifying the content of right panel. 
            if let selection, let game = games.first(where: { $0.id == selection }) {
                CodeBreakerView(game: game)
                    .navigationTitle(game.name)
                    .navigationBarTitleDisplayMode(.inline)
            } else {
                Text("Choose a Game!")
            }
        }
        
    }
}

#Preview {
    @Previewable @State var games = [
        CodeBreaker(
            name: "Ocean",
            numOfPegs: 3,
            pegChoices: [.blue, .cyan, .teal, .indigo]
        ),
        CodeBreaker(
            name: "Forest",
            numOfPegs: 4,
            pegChoices: [.green, .mint, .brown, .yellow]
        ),
        CodeBreaker(
            name: "Sunset",
            numOfPegs: 5,
            pegChoices: [.red, .orange, .pink, .purple, .yellow]
        )
    ]
    
    GameChooser(games: $games)
}
