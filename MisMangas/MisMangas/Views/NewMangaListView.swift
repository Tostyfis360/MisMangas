//
//  NewMangaListView.swift
//  MisMangas
//
//  Created by Juan Ferrera Sala on 8/1/26.
//

import SwiftUI
import SwiftData

@MainActor let isiPhone = UIDevice.current.userInterfaceIdiom == .phone

struct NewMangaListView: View {
    @State private var vm = MangaListVM()
    @Namespace private var namespace
    @Query private var userCollection: [UserMangaCollection]
    var onDataLoaded: (() -> Void)?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    // HERO CAROUSEL
                    if !vm.mangas.isEmpty {
                        HeroCarouselView(
                            mangas: Array(topRatedMangas.prefix(5)),
                            namespace: namespace)
                    }
                    VStack(spacing: 30) {
                        // CONTINUAR LEYENDO
                        if !continueReadingMangas.isEmpty {
                            MangaRowView(
                                title: "Continuar leyendo",
                                mangas: continueReadingMangas,
                                namespace: namespace,
                                isClickable: false)
                        }
                        // MEJOR VALORADOS
                        if !topRatedMangas.isEmpty {
                            MangaRowView(
                                title: "Mejor valorados",
                                mangas: topRatedMangas,
                                namespace: namespace,
                                isClickable: false)
                        }
                        // CATEGORÍAS
                        ForEach(categoryRows, id: \.title) { row in
                            MangaRowView(
                                title: row.title,
                                mangas: row.mangas,
                                namespace: namespace)
                        }
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 20)
                }
            }
            .ignoresSafeArea(edges: .top)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Mis mangas")
                        .font(.title3)
                        .bold()
                }
            }
            .toolbarRole(.editor)
            .toolbarBackground(.hidden, for: .navigationBar)
            .navigationDestination(for: MangaDTO.self) { manga in
                NewMangaDetailView(manga: manga, namespace: namespace)
            }
            .navigationDestination(for: CategoryNavigation.self) { categoryNav in
                CategoryGridView(
                    category: categoryNav.title,
                    filterType: categoryNav.filterType)
            }
        }
        .task {
            if vm.mangas.isEmpty {
                await vm.loadInitialData()
                onDataLoaded?()
            }
        }
    }

    // MARK: - Continuar Leyendo
    private var continueReadingMangas: [MangaDTO] {
        // Mangas en tu colección que NO están completos
        let unfinishedIds = userCollection
            .filter { !$0.completeCollection }
            .map { $0.mangaId }
        return vm.mangas.filter { unfinishedIds.contains($0.id) }
    }

    // MARK: - Mejor Valorados
    private var topRatedMangas: [MangaDTO] {
        vm.mangas
            .filter { $0.score != nil }
            .sorted { ($0.score ?? 0) > ($1.score ?? 0) }
            .prefix(10)
            .map { $0 }
    }

    // MARK: - Category Rows
    private var categoryRows: [(title: String, mangas: [MangaDTO])] {
        var rows: [(String, [MangaDTO])] = []
        
        // Action
        let actionMangas = vm.mangas.filter { manga in
            manga.genres.contains { $0.genre.lowercased() == "action" }
        }
        if !actionMangas.isEmpty {
            rows.append(("Action", Array(actionMangas.prefix(10))))
        }
        // Shounen
        let shounenMangas = vm.mangas.filter { manga in
            manga.demographics.contains { $0.demographic.lowercased() == "shounen" }
        }
        if !shounenMangas.isEmpty {
            rows.append(("Shounen", Array(shounenMangas.prefix(10))))
        }
        // Romance
        let romanceMangas = vm.mangas.filter { manga in
            manga.genres.contains { $0.genre.lowercased() == "romance" }
        }
        if !romanceMangas.isEmpty {
            rows.append(("Romance", Array(romanceMangas.prefix(10))))
        }
        // Adventure
        let adventureMangas = vm.mangas.filter { manga in
            manga.genres.contains { $0.genre.lowercased() == "adventure" }
        }
        if !adventureMangas.isEmpty {
            rows.append(("Adventure", Array(adventureMangas.prefix(10))))
        }
        // Comedy
        let comedyMangas = vm.mangas.filter { manga in
            manga.genres.contains { $0.genre.lowercased() == "comedy" }
        }
        if !comedyMangas.isEmpty {
            rows.append(("Comedy", Array(comedyMangas.prefix(10))))
        }
        return rows
    }
}

#Preview {
    NewMangaListView()
        .modelContainer(for: UserMangaCollection.self, inMemory: true)
}
