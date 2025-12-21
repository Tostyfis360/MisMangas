//
//  MisMangasApp.swift
//  MisMangas
//
//  Created by Juan Ferrera Sala on 20/12/25.
//

import SwiftUI
import SwiftData

@main
struct MisMangasApp: App {
    var body: some Scene {
        WindowGroup {
            MainTab()
        }
        .modelContainer(for: UserMangaCollection.self)
    }
}
