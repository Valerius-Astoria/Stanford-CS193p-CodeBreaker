//
//  CodeBreaker2App.swift
//  CodeBreaker2
//
//  Created by ZAKA on 10/13/26.
//

import SwiftUI

@main
struct CodeBreaker2App: App {
    @State private var game = CodeBreaker(name: "CodeBreaker", numOfPegs: 4, pegChoices: [.red, .green, .blue, .yellow])
    
    var body: some Scene {
        WindowGroup {
            CodeBreakerView(game: game)
        }
    }
}
