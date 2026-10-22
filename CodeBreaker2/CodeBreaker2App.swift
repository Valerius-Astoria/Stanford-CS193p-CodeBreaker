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
    var body: some Scene {
        WindowGroup {
            GameChooser()
                .modelContainer(for: CodeBreaker.self)
        }
    }
}
