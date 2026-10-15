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
        .toolbar {
            // Adds the restart button to the tool bar.
            ToolbarItem(placement: .primaryAction) {
                Button("Restart", systemImage: "arrow.circlepath", action: game.restart)
            }
        }
        .padding()
    }
    
    /// Renders the view for a code, supporting rendering master code, current guess , and previous attempts.
    func view(for code: Code) -> some View {
//        let _ = print("Level 1: \(code.kind)")
        return HStack {
            // Renders the pegs for a single code.
            // ATTENTION (for the deprecated implementation): ForEach decides whether to update its view based on its data and ids. If code.kind is changed but code.pegs.indices are not, the view for each peg would not be updated.
            ForEach(Array(code.pegs.enumerated()), id: \.offset) { index, peg in
                pegView(for: peg, in: code, at: index)
            }
            // Renders the guess button for the current guess, and matching results for previous attempts.
            MatchMarkers(matches: code.matches)
                .overlay {
                    if code.kind == .guess, !game.isOver {
                        Button("Guess", action: game.attemptGuess).flexibleSystemFont()
                    }
                }
        }
    }
    
    ///  Renders the view for a single peg.
    ///
    ///  - Parameter peg: The peg to render.
    ///  - Parameter in: The code containing the peg.
    ///  - Parameter index: Index of the peg.
    func pegView(for peg: Peg, in code: Code, at index: Int) -> some View {
//        let _ = print("Level 2: \(code.kind)")
        return PegView(peg: peg)
            // Renders the background of the selected peg.
            .background {
                if selection == index, code.kind == .guess {
                    Selection.shape
                        .foregroundStyle(Selection.color)
                }
            }
            // Allows pegs to be selected by tapping.
            .onTapGesture {
                if code.kind == .guess {
                    selection = index
                }
            }
            // Masks the master code when it's not matched with the current guess.
            .overlay {
                if (code.kind == .master(isHidden: true)) {
                    Mask.shape
                        .foregroundStyle(Mask.color)
                    
                }
            }
    }
}

// MARK: - UI Constants
extension CodeBreakerView {
    struct Selection {
        static let cornerRadius: CGFloat = 10
        static let color: Color = .gray(0.85)
        static let shape = RoundedRectangle(cornerRadius: Selection.cornerRadius)
    
    }
    
    struct Mask {
        static let cornerRadius: CGFloat = 10
        static let color: Color = .gray
        static let shape = RoundedRectangle(cornerRadius: Mask.cornerRadius)
    }
}

#Preview {
    @Previewable @State var game = CodeBreaker(name: "Test Game", numOfPegs: 4, pegChoices: [.red, .green, .blue, .yellow])
    
    NavigationView {
        CodeBreakerView(game: game)
    }
}
