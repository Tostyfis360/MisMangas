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
    init() {
        FileManagerHelper.ensureAppDirectoriesExist()
    }
    @State private var authManager = AuthManager.shared
    var body: some Scene {
        WindowGroup {
            Group {
                if authManager.isCheckingAuth {
                    LoadingView()
                } else if authManager.isAuthenticated {
                    MainTab()
                } else {
                    LoginView()
                }
            }
            .preferredColorScheme(.dark)
        }
        .modelContainer(for: UserMangaCollection.self)
    }
}
