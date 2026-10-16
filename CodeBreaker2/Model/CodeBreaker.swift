//
//  CodeBreaker.swift
//  CodeBreaker2
//
//  Created by ZAKA on 10/13/26.
//

import SwiftUI
import Observation

typealias Peg = Color // Each geg is represented by a color

/// The state and rules for a CodeBreaker game.
@Observable
class CodeBreaker: Identifiable {
    var id = UUID()
    
    var name: String
    var numOfPegs: Int
    var pegChoices: [Peg]
    
    var masterCode: Code
    var guess: Code
    var attempts: [Code] = []
    
    var isOver: Bool {
        masterCode.kind == .master(isHidden: false)
    }
    
    init(name: String, numOfPegs: Int, pegChoices: [Peg]) {
        self.name = name
        self.numOfPegs = numOfPegs
        self.pegChoices = pegChoices
        
        self.masterCode = Code(kind: .master(isHidden: true), count: numOfPegs)
        self.guess = Code(kind: .guess, count: numOfPegs) // Initialize guess with empty pegs.
        
        self.masterCode.randomize(from: pegChoices) // Randomly generates the correct peg color combination.
        print(self.masterCode.pegs)
    }
    
    /// Changes the peg color at a specific position in the current guess.
    ///
    /// The color is changed to the next available color in the `pegChoices` array, cycling back to the first color if the end of the array is reached.
    /// If the current is not found in the`pegChoices` array, which should not happen, it defaults to `Color.clear`.
    ///
    /// - Parameter index: The index of the peg in the current guess to change.
    func changeGuessPeg(at index: Int) {
        // Gets the current color of the target peg.
        let existingPeg = guess.pegs[index]
        var updatedGuess = guess
        // Calculates the next color and assigns it to the peg in the current guess.
        if let existingIndex = pegChoices.firstIndex(of: existingPeg) {
            let nextIndex = (existingIndex + 1) % pegChoices.count
            updatedGuess.pegs[index] = pegChoices[nextIndex]
        } else {
            updatedGuess.pegs[index] = Peg.missing
        }
        guess = updatedGuess
    }
    
    /// Sets the peg color at a specific position in the current guess.
    ///
    /// - Parameter peg: The new color for the target peg. 
    /// - Parameter index: The index of the peg in the current guess to change.
    func setGuessPeg(_ peg: Peg, at index: Int) {
        var updatedGuess = guess
        updatedGuess.pegs[index] = peg
        guess = updatedGuess
    }
    
    /// Attempts a guess against the master code, stores the attempt to the `attempts` array, and checks whether the guess matches the master code.
    ///
    /// If the current guess is not valid, the attempt will not be added to the array.
    func attemptGuess() {
        // Computes the matching result for the current guess against the ,aster code.
        let matches = guess.match(against: masterCode)
        // Constructs the current attempt based on guess
        let attempt = Code(kind: .attempt(matches), pegs: guess.pegs)
        // Checks if the current attempt is sementic to any previous attempts.
        guard valid(code: attempt) else { return } // Early exists if the guess is invalid.
        
        // Checks if the current guess matches the master code.
        if matches.allSatisfy({ $0 == .exact }) {
            self.masterCode.kind = .master(isHidden: false)
        } else {
            // Inserts the current attempt at the beginning of the attempts array.
            attempts.insert(attempt, at: 0)
            // Reinitialize guess with empty pegs
            guess = Code(kind: .guess, count: numOfPegs)
        }
    }
    
    /// Restarts the game with pegChoices kept to be the same.
    func restart() {
        masterCode.randomize(from: pegChoices)
        masterCode.kind = .master(isHidden: true)
        guess = Code(kind: .guess, count: numOfPegs)
        attempts.removeAll()
        print(self.masterCode.pegs)
    }
    
    /// Validates the current attempt. If the attempt is sementic to any previous attempts, or the attempt is empty, the validation would fail.
    ///
    /// - Returns: The validation result.
    private func valid(code: Code) -> Bool {
        !(attempts.contains {$0.pegs == code.pegs} || code.pegs == Array(repeating: Peg.missing, count: attempts.count))
    }
}

extension CodeBreaker: Equatable {
    static func == (lhs: CodeBreaker, rhs: CodeBreaker) -> Bool { lhs === rhs }
}
