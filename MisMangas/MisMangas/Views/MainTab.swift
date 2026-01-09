//
//  MainTab.swift
//  MisMangas
//
//  Created by Juan Ferrera Sala on 21/12/25.
//

import SwiftUI

struct MainTab: View {
    var body: some View {
        TabView {
            Tab("Catálogo", systemImage: "books.vertical") {
                NewMangaListView()
            }
            
            Tab("Mi Colección", systemImage: "book.closed") {
                CollectionView()
            }
            Tab("Explorar", systemImage: "magnifyingglass", role: .search) {
                ExploreView()
            }
        }
        .tabBarMinimizeBehavior(.onScrollDown)
        .tabViewStyle(.sidebarAdaptable)
        .defaultAdaptableTabBarPlacement(.tabBar)
    }
}

#Preview {
    MainTab()
}
