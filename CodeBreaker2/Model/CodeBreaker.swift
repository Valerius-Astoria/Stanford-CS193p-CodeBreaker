//
//  CodeBreaker.swift
//  CodeBreaker2
//
//  Created by ZAKA on 10/13/26.
//

import SwiftUI

typealias Peg = Color // Each geg is represented by a color

/// The state and rules for a CodeBreaker game.
class CodeBreaker {
    var name: String
    var numOfPegs: Int
    var pegChpoices: [Peg]
    
    var masterCode: Code
    var guess: Code
    var attempts: [Code] = []
    
    var isOver: Bool = false // TODO: Change to a computed property
    
    init(name: String, numOfPegs: Int, pegChpoices: [Peg]) {
        self.name = name
        self.numOfPegs = numOfPegs
        self.pegChpoices = pegChpoices
        
        self.masterCode = Code(kind: .master(isHidden: false), count: numOfPegs)
        self.guess = Code(kind: .guess, count: numOfPegs) // Initialize guess with empty pegs.
        
        self.masterCode.randomize(from: pegChpoices) // Randomly generates the correct peg color combination.
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
        // Calculates the next color and assigns it to the peg in the current guess.
        if let existingIndex = pegChpoices.firstIndex(of: existingPeg) {
            let nextIndex = (existingIndex + 1) % pegChpoices.count
            guess.pegs[index] = pegChpoices[nextIndex]
        } else {
            guess.pegs[index] = Peg.missing
        }
    }
    
    /// Sets the peg color at a specific position in the current guess.
    ///
    /// - Parameter peg: The new color for the target peg. 
    /// - Parameter index: The index of the peg in the current guess to change.
    func setGuessPeg(_ peg: Peg, at index: Int) {
        guess.pegs[index] = peg
    }
    
    /// Attempts a guess against the master code, stores the attempt to the `attempts` array, and checks whether the guess matches the master code.
    ///
    /// If the current guess is not valid, the attempt will not be added to the array.
    ///
    /// - Returns: Whether the guess is successfully performed.
    func attemptGuess() -> Bool {
        // Computes the matching result for the current guess against the ,aster code.
        let matches = guess.match(against: masterCode)
        // Constructs the current attempt based on guess
        let attempt = Code(kind: .attempt(matches), pegs: guess.pegs)
        // Checks if the current attempt is sementic to any previous attempts.
        guard valid(code: attempt) else { return false } // Early exists if the guess is invalid.
        // Inserts the current attempt at the beginning of the attempts array.
        attempts.insert(attempt, at: 0)
        // Checks if the current guess matches the master code.
        if matches.allSatisfy({ $0 == .exact }) {
            masterCode.kind = .master(isHidden: true)
        }
        // Reinitialize guess with empty pegs.
        guess = Code(kind: .guess, count: numOfPegs)
    }
    
    /// Restarts the game with pegChoices kept to be the same.
    func restart() {
        masterCode.randomize(from: pegChpoices)
        guess = Code(kind: .guess, count: numOfPegs)
        attempts.removeAll()
    }
    
    /// Validates the current attempt. If the attempt is sementic to any previous attempts, or the attempt is empty, the validation would fail.
    ///
    /// - Returns: The validation result.
    private func valid(code: Code) -> Bool {
        !(attempts.contains {$0.pegs == code.pegs} || code.pegs == Array(repeating: Peg.missing, count: attempts.count))
    }
}
