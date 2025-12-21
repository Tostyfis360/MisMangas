//
//  PreviewContainer.swift
//  MisMangas
//
//  Created by Juan Ferrera Sala on 21/12/25.
//

import SwiftUI
import SwiftData

struct PreviewContainer: PreviewModifier {
    static func makeSharedContext() async throws -> ModelContainer {
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: UserMangaCollection.self, configurations: configuration)
        
        UserMangaCollection.sampleCollections.forEach { collection in
            container.mainContext.insert(collection)
        }
        
        try container.mainContext.save()
        return container
    }
    
    func body(content: Content, context: ModelContainer) -> some View {
        content
            .modelContainer(context)
    }
}

extension PreviewTrait where T == Preview.ViewTraits {
    @MainActor static var sampleData: Self = .modifier(PreviewContainer())
}
