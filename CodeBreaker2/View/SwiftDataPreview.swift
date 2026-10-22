//
//  SwiftDataPreview.swift
//  CodeBreaker2
//
//  Created by ZAKA on 10/21/26.
//

import SwiftUI
import SwiftData

struct SwiftDataPreview: PreviewModifier {
    static func makeSharedContext() async throws -> ModelContainer {
        let container = try ModelContainer(for: CodeBreaker.self, configurations: ModelConfiguration.init(isStoredInMemoryOnly: true))
        let context = container.mainContext
        
        for game in CodeBreaker.sampleData { // Inserts sample data into the model context. 
            context.insert(game)
        }
        
        return container
    }
    
    func body(content: Content, context: ModelContainer) -> some View {
        content.modelContainer(context)
    }
}

extension PreviewTrait<Preview.ViewTraits> {
    @MainActor static var swiftData: Self = .modifier(SwiftDataPreview())
}
