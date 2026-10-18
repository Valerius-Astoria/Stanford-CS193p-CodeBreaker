//
//  Code.swift
//  CodeBreaker2
//
//  Created by ZAKA on 10/13/26.
//

import Foundation

struct Code: Identifiable, Hashable {
    let id = UUID()
    
    var kind: Kind
    var pegs: [Peg]
    let count: Int
    
    var matches: [Match] {
        switch kind {
            case .attempt(let matches): return matches
            default:  return []
        }
    }
    
    /// Generates a new code with specified kind and `count` of pegs, all initialized to `Peg.missing`.
    init(kind: Kind, count: Int) {
        self.kind = kind
        self.count = count
        self.pegs = Array(repeating: Peg.missing, count: count)
    }
    
    /// Generates a new code with specified kind and an array of pegs.
    init (kind: Kind, pegs: [Peg]) {
        self.kind = kind
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
    mutating func randomize(from pegChoices: [Peg]) {
        pegs = (0..<count).compactMap { _ in pegChoices.randomElement()}
    }
    
    /// Kind of Code: guess, attempt, or master.
    enum Kind: Equatable {
        case guess
        case attempt([Match])
        case master(isHidden: Bool)
    }
    
    /// Kind of match result: exact, inexact, or nomatch.
    enum Match {
        case exact
        case inexact
        case nomatch
    }
}

extension Code {
    static func == (lhs: Code, rhs: Code) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
