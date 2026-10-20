//
//  GameEditor.swift
//  CodeBreaker2
//
//  Created by ZAKA on 10/18/26.
//

import SwiftUI

struct GameEditor: View {
    
    // MARK: - Data (Function) In
    @Environment(\.dismiss) var dismiss
    
    // MARK: -  Data Shared with Me
    @Bindable var game: CodeBreaker
    
    // MARK: - Action Function
    var onChoose: () -> Void
    
    var body: some View {
        NavigationStack {
            Form {
                // Game name editor.
                Section {
                    TextField("Name", text: $game.name)
                }
                // Color Pickers.
                Section {
                    PegChoicesChooser(pegChoices: $game.pegChoices)
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        onChoose()
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    let game = CodeBreaker(name: "Test Game", numOfPegs: 4, colors: [.red, .green, .blue, .yellow])
    GameEditor(game: game, onChoose: {})
}
