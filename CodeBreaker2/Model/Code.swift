//
//  Code.swift
//  CodeBreaker2
//
//  Created by ZAKA on 10/13/26.
//

import Foundation
import SwiftData

@Model class Code {
    var _kind: String
    var pegs: [Peg]
    var count: Int
    
    var kind: Kind { // converts to and from String
        get { Kind(storageValue: _kind) }
        set { _kind = newValue.storageValue }
    }
    
    var matches: [Match] {
        switch kind {
            case .attempt(let matches): return matches
            default:  return []
        }
    }
    
    /// Generates a new code with specified kind and `count` of pegs, all initialized to `Peg.missing`.
    init(kind: Kind, count: Int) {
        self._kind = kind.storageValue
        self.count = count
        self.pegs = Array(repeating: Peg.missing, count: count)
    }
    
    /// Generates a new code with specified kind and an array of pegs.
    init(kind: Kind, pegs: [Peg]) {
        self._kind = kind.storageValue
        self.pegs = pegs
        self.count = pegs.count
    }
    
    /// Calculates the match results for a guess against another code.
    ///
    /// When the color and position of a peg in the guess matches the color and position of a peg in the master code, it is considered an exact match.
    /// When the color of a peg in the guess matches the color of a peg in the master code, but the positions do not match, it is considered an inexact match.
    /// When the color of a peg in the guess does not match any peg in the master code, it is considered a no match.
    ///
    /// Examples:
    /// - If the master code is `[red, blue, green, yellow]` and the guess is `[red, green, blue, purple]`, the match results would be `[exact, inexact, inexact, nomatch]`.
    /// - If the  If the master code is `[red, blue, green, yellow]` and the guess is `[red, red, red, red]`, the match results would be `[exact, nomatch, nomatch, nomatch]`.
    func match(against otherCode: Code) -> [Match] {
        
        // Initializes the result array with `.nomatch` for each peg.
        var result: [Match] = Array(repeating: .nomatch, count: pegs.count)
        // Creates a mutable copy of the other code's pegs to track which pegs have already been matched.
        var remaining = otherCode.pegs
        
        for index in pegs.indices where pegs[index] != .missing && pegs[index] == remaining[index] {
            result[index] = .exact
            remaining[index] = .missing
        }
        
        for index in pegs.indices where result[index] != .exact && pegs[index] != .missing {
            if let matchIndex = remaining.firstIndex(of: pegs[index]) {
                result[index] = .inexact
                remaining[matchIndex] = .missing
            }
        }
       
        return result
    }
    
    /// Randomlly select `count` number of colors from `pegChoices`. 
    func randomize(from pegChoices: [Peg]) {
        pegs = (0..<count).compactMap { _ in pegChoices.randomElement()}
    }
    
    /// Kind of Code: guess, attempt, or master.
    ///
    /// If you nake Kind Codable, the search function of SwiftData will be pretty limited. Same for Match.
    enum Kind: Equatable {
        case guess
        case attempt([Match])
        case master(isHidden: Bool)

        /// The string persisted in the database, e.g. "guess", "master:hidden", "attempt:eini".
        var storageValue: String {
            switch self {
            case .guess: "guess"
            case .attempt(let matches): "attempt:" + matches.map(\.rawValue).joined()
            case .master(let isHidden): isHidden ? "master:hidden" : "master:visible"
            }
        }

        /// Rebuilds a kind from its persisted string. Unknown values fall back to `.guess`.
        init(storageValue: String) {
            let parts = storageValue.split(separator: ":", maxSplits: 1, omittingEmptySubsequences: false)
            let payload = parts.count > 1 ? String(parts[1]) : ""
            switch String(parts[0]) {
            case "attempt":
                self = .attempt(payload.compactMap { Match(rawValue: String($0)) })
            case "master":
                self = .master(isHidden: payload != "visible")
            default:
                self = .guess
            }
        }
    }
    
    /// Kind of match result: exact, inexact, or nomatch.
    enum Match: String {
        case exact = "e"
        case inexact = "i"
        case nomatch = "n"
    }
}
