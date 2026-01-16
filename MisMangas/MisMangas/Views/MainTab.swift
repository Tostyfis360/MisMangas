//
//  MainTab.swift
//  MisMangas
//
//  Created by Juan Ferrera Sala on 21/12/25.
//

import SwiftUI
import SwiftData

struct MainTab: View {
    @State private var isLoading = true
    @State private var syncManager = SyncManager()

    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        ZStack {
            // App principal
            TabView {
                Tab("Inicio", systemImage: "house.fill") {
                    NewMangaListView(onDataLoaded: {
                        withAnimation(.easeOut(duration: 0.5)) {
                            isLoading = false
                        }
                    })
                }
                Tab("Mi Colección", systemImage: "book.closed") {
                    CollectionView()
                }
                Tab("Explorar", systemImage: "magnifyingglass", role: .search) {
                    ExploreView()
                }
            }
            .tint(.primary)
            .tabBarMinimizeBehavior(.onScrollDown)
            .tabViewStyle(.sidebarAdaptable)
            .defaultAdaptableTabBarPlacement(.tabBar)
            .opacity(isLoading ? 0 : 1)
            // Loading overlay
            if isLoading {
                LoadingView()
                    .transition(.opacity)
            }
        }
        .task {
            // Sincronizar colección al entrar
            await syncManager.syncDown(modelContext: modelContext)
        }
    }
}

#Preview {
    MainTab().modelContainer(for: UserMangaCollection.self, inMemory: true)
}
