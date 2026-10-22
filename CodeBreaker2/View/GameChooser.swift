//
//  GameChooser.swift
//  CodeBreaker2
//
//  Created by ZAKA on 10/16/26.
//

import SwiftUI
import SwiftData

struct GameChooser: View {
    
    // MARK: - Data In
    @Environment(\.modelContext) var modelContext
    
    // MARK: - Data Shared with Me
    @Query(sort: \CodeBreaker.name, order: .forward) private var games: [CodeBreaker]
    
    // MARK: - Data Owned by Me
    @State private var selection: CodeBreaker.ID?
    @State private var showGameEditor = false
    @State private var gameToEdit: CodeBreaker?
    
    // MARK: - Body
    var body: some View {
        NavigationSplitView {
            // Renders the list of available games.
            List {
                ForEach(games) { game in
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
                .onDelete(perform: deleteGames)
            }
            .toolbar {
                EditButton()
                addButton
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
    
    var addButton: some View {
        Button("Add", systemImage: "plus") {
            gameToEdit = CodeBreaker(name: "Untitled", numOfPegs: 4, colors: [.green, .blue, .red, .yellow])
        }
        .onChange(of: gameToEdit) { // ensures game editor is shown only when gameToEdit is not nil.
            showGameEditor = gameToEdit != nil
        }
        .sheet(isPresented: $showGameEditor, onDismiss: { gameToEdit = nil }) {
            gameEditor
        }
    }
    
    @ViewBuilder
    var gameEditor: some View {
        if let gameToEdit {
            GameEditor(game: gameToEdit) {
                modelContext.insert(gameToEdit)
            }
        }
    }
    
    /// Deletes games from the database.
    private func deleteGames(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(games[index])
        }
    }
}

#Preview(traits: .swiftData)  {
    GameChooser()
}
