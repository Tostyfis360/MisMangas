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
                MangaListView()
            }
            
            Tab("Mi Colección", systemImage: "book.closed") {
                CollectionView()
            }
            Tab("Buscar", systemImage: "magnifyingglass", role: .search) {
                SearchView()
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
