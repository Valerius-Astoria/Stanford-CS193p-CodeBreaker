//
//  Code.swift
//  CodeBreaker2
//
//  Created by ZAKA on 10/13/26.
//

import Foundation

struct Code {
    var kind: Kind
    var pegs: [Peg]
    let count: Int
    
    /// Generate a new code with specified kind and `count` of pegs, all initialized to `Peg.missing`.
    init(kind: Kind, count: Int) {
        self.kind = kind
        self.count = count
        self.pegs = Array(repeating: Peg.missing, count: count)
    }
    
    /// Generate a new code with specified kind and an array of pegs.
    init (kind: Kind, pegs: [Peg]) {
        self.kind = kind
        self.pegs = pegs
        self.count = pegs.count
    }
    
    func match(against otherCode: Code) -> [Match] {
        
    }
    
    /// Randomize the code's pegs by selecting from the provided `pegChoices`.
    mutating func randomize(from pegChoices: [Peg]) {
        pegs = (0..<count).compactMap { _ in pegChoices.randomElement()}
    }
    
    /// Kind of Code: guess, attempt, or master.
    enum Kind {
        case guess
        case attempt([Match])
        case master(isHidden: Bool)
    }
}

enum Match {
    case exact
    case inexact
    case nomatch
}
