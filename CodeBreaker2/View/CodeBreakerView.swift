//
//  ContentView.swift
//  CodeBreaker2
//
//  Created by ZAKA on 10/13/26.
//

import SwiftUI

struct CodeBreakerView: View {
    
    // MARK: - Data In
    var game: CodeBreaker
    
    // MARK: - Data Owned by Me
    @State private var selection = 0
    
    // MARK: - Body
    var body: some View {
        VStack {
            // Renders the master code for the game.
            view(for: game.masterCode)
            
            // Renders the current guess and previous attempts in a scrollable area.
            ScrollView {
                view(for: game.guess)
                
                ForEach(game.attempts, id: \.self) { attempt in
                    view(for: attempt)
                }
            }
            
            // Renders the peg chooser for selecting peg colors.
            PegChooser(game: game, selection: $selection)
        }
        .padding()
    }
    
    /// Renders the view for a code, supporting rendering master code, current guess , and previous attempts.
    func view(for code: Code) -> some View {
        HStack {
            // Renders the pegs for a single code.
            ForEach(code.pegs.indices, id: \.self) { index in
                pegView(for: code.pegs[index], in: code, at: index)
            }
            
            // Renders the guess button for the current guess, and matching results for previous attempts.
            MatchMarkers(matches: code.matches)
                .overlay {
                    if code.kind == .guess {
                        Button("Guess", action: game.attemptGuess)
                    }
                }
        }
    }
    
    ///  Renders the view for a single peg.
    ///
    ///  - Parameter peg: The peg to render.
    ///  - Parameter in: The code of the peg.
    ///  - Parameter index: The index of the peg in the given code.
    func pegView(for peg: Peg, in code: Code, at index: Int) -> some View {
        PegView(peg: peg)
            .background {
                if selection == index, code.kind == .guess{
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundStyle(.gray)
                }
            }
            .onTapGesture {
                if code.kind == .guess {
                    selection = index
                }
            }
    }
}

#Preview {
    @Previewable var game = CodeBreaker(name: "Test Game", numOfPegs: 4, pegChoices: [.red, .green, .blue, .yellow])
    CodeBreakerView(game: game)
}
