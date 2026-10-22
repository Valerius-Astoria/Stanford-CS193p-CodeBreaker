//
//  CodeBreaker.swift
//  CodeBreaker2
//
//  Created by ZAKA on 10/13/26.
//

import SwiftUI
import SwiftData

typealias Peg = String // Each peg is represented by a hex color string.

/// The state and rules for a CodeBreaker game.
@Model class CodeBreaker {   // @Model already provides Identifiable

    var name: String
    var numOfPegs: Int
    var pegChoices: [Peg]

    @Relationship(deleteRule: .cascade) var masterCode: Code
    @Relationship(deleteRule: .cascade) var guess: Code
    @Relationship(deleteRule: .cascade) var attempts: [Code] = []

    var isOver: Bool {
        masterCode.kind == .master(isHidden: false)
    }

    init(name: String, numOfPegs: Int, pegChoices: [Peg]) {
        self.name = name
        self.numOfPegs = numOfPegs
        self.pegChoices = pegChoices
        self.masterCode = Code(kind: .master(isHidden: true), count: numOfPegs)
        self.guess = Code(kind: .guess, count: numOfPegs)
        self.masterCode.randomize(from: pegChoices)
    }

    /// Cycles the peg at `index` in the current guess to the next color in `pegChoices`.
    ///
    /// If the current peg isn't in `pegChoices` (e.g. it's `Peg.missing`), it becomes the first choice.
    func changeGuessPeg(at index: Int) {
        let existingPeg = guess.pegs[index]
        if let existingIndex = pegChoices.firstIndex(of: existingPeg) {
            guess.pegs[index] = pegChoices[(existingIndex + 1) % pegChoices.count]
        } else {
            guess.pegs[index] = pegChoices[0]
        }
    }

    /// Sets the peg at `index` in the current guess.
    func setGuessPeg(_ peg: Peg, at index: Int) {
        guess.pegs[index] = peg
    }

    /// Records the current guess as an attempt and checks whether it cracks the master code.
    ///
    /// Invalid guesses (empty, or identical to a previous attempt) are ignored.
    func attemptGuess() {
        let matches = guess.match(against: masterCode)
        let attempt = Code(kind: .attempt(matches), pegs: guess.pegs)
        guard valid(code: attempt) else { return }

        if matches.allSatisfy({ $0 == .exact }) {
            masterCode.kind = .master(isHidden: false)
        } else {
            attempts.insert(attempt, at: 0)
            guess.pegs = Array(repeating: Peg.missing, count: numOfPegs)
        }
    }

    /// Restarts the game, keeping the same `pegChoices`.
    func restart() {
        masterCode.randomize(from: pegChoices)
        masterCode.kind = .master(isHidden: true)
        guess.pegs = Array(repeating: Peg.missing, count: numOfPegs)
        attempts.removeAll()
    }

    /// An attempt is invalid if it's empty or duplicates a previous attempt.
    private func valid(code: Code) -> Bool {
        let isEmpty = code.pegs.allSatisfy { $0 == .missing }
        let isDuplicate = attempts.contains { $0.pegs == code.pegs }
        return !isEmpty && !isDuplicate
    }
}

extension Peg {
    /// A transparent placeholder for an empty slot.
    static let missing = "#00000000"
}

extension CodeBreaker {
    /// Creates a game from colors, storing them as hex strings.
    convenience init(name: String, numOfPegs: Int, colors: [Color]) {
        self.init(name: name, numOfPegs: numOfPegs, pegChoices: colors.map(\.hexString))
    }
}

extension CodeBreaker {
    // Creates sample data for testing. 
    static var sampleData: [CodeBreaker] = [
        CodeBreaker(
            name: "Ocean",
            numOfPegs: 3,
            colors: [.blue, .cyan, .teal, .indigo]
        ),
        CodeBreaker(
            name: "Forest",
            numOfPegs: 4,
            colors: [.green, .mint, .brown, .yellow]
        ),
        CodeBreaker(
            name: "Sunset",
            numOfPegs: 5,
            colors: [.red, .orange, .pink, .purple, .yellow]
        )
    ]
}
