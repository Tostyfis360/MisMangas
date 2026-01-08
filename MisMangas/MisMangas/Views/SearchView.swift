//
//  SearchView.swift
//  MisMangas
//
//  Created by Juan Ferrera Sala on 8/1/26.
//
import SwiftUI
import SwiftData

struct SearchView: View {
    @State private var vm = SearchVM()
    @Namespace private var namespace
    
    var body: some View {
        NavigationStack {
            Group {
                if vm.mangaResult.isEmpty {
                    emptyStateView
                } else {
                    resultsList
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Buscar")
                        .font(.title3)
                        .bold()
                }
            }
            .toolbarRole(.editor)
            .searchable(text: $vm.search, prompt: "Buscar manga por título")
            .onChange(of: vm.search) {
                if vm.search.count >= 3 {
                    Task {
                        await vm.findMangas()
                    }
                }
            }
            .navigationDestination(for: MangaDTO.self) { manga in
                NewMangaDetailView(manga: manga, namespace: namespace)
            }
        }
    }
    
    // MARK: - Empty State View
    private var emptyStateView: some View {
        Group {
            if vm.search.isEmpty {
                ContentUnavailableView(
                    "Sin búsqueda",
                    systemImage: "magnifyingglass.circle",
                    description: Text("Escribe al menos 3 caracteres para buscar un manga por su título."))
            } else if vm.search.count <= 2 {
                ContentUnavailableView(
                    "Sigue escribiendo",
                    systemImage: "keyboard",
                    description: Text("Escribe al menos 3 caracteres para buscar."))
            } else if !vm.search.isEmpty {
                ContentUnavailableView(
                    "Sin resultados",
                    systemImage: "book.closed",
                    description: Text("No se encontraron mangas con ese título."))
            }
        }
    }
    
    // MARK: - Results List
    private var resultsList: some View {
        ScrollView {
            if isiPhone {
                LazyVStack(spacing: 12) {
                    mangaItems
                }
                .safeAreaPadding()
            } else {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 300), spacing: 16)], spacing: 16) {
                    mangaItems
                }
                .safeAreaPadding()
            }
        }
    }
    
    // MARK: - Manga Items
    @ViewBuilder
    private var mangaItems: some View {
        ForEach(vm.mangaResult) { manga in
            NavigationLink(value: manga) {
                MangaCardView(manga: manga, namespace: namespace)
            }
            .buttonStyle(.plain)
        }
    }
}

#Preview {
    SearchView()
        .modelContainer(for: UserMangaCollection.self, inMemory: true)
}
