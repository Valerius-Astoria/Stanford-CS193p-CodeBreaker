//
//  CodeBreaker2App.swift
//  CodeBreaker2
//
//  Created by ZAKA on 10/13/26.
//

import SwiftUI
import SwiftData

@main
struct CodeBreaker2App: App {
    @State private var games = [
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
    
    var body: some Scene {
        WindowGroup {
            GameChooser(games: $games)
                .modelContainer(for: CodeBreaker.self)
        }
    }
}
