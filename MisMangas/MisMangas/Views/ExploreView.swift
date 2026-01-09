//
//  ExploreView.swift
//  MisMangas
//
//  Created by Juan Ferrera Sala on 9/1/26.
//

import SwiftUI

struct ExploreView: View {
    @State private var vm = ExploreVM()
    @Namespace private var namespace

    // Grid columns
    private let gridColumns = [
        GridItem(.adaptive(minimum: isiPhone ? 110 : 180), spacing: 16)]

    var body: some View {
        NavigationStack {
            Group {
                if vm.displayMangas.isEmpty {
                    emptyStateView
                } else {
                    mangaGrid
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Explorar")
                        .font(.title3)
                        .bold()
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    filterMenu
                }
            }
            .toolbarRole(.editor)
            .searchable(text: $vm.search, prompt: "Buscar manga por título")
            .onChange(of: vm.search) {
                if vm.search.count >= 3 {
                    Task {
                        await vm.findMangas()
                    }
                } else if vm.search.isEmpty {
                    // Limpiar la búsqueda
                    vm.searchResults = []
                }
            }
            .navigationDestination(for: MangaDTO.self) { manga in
                NewMangaDetailView(manga: manga, namespace: namespace)
            }
        }
        .task {
            if vm.mangas.isEmpty {
                await vm.loadInitialData()
            }
        }
    }

    // MARK: - Manga Grid
    private var mangaGrid: some View {
        ScrollView {
            LazyVGrid(columns: gridColumns, spacing: 16) {
                ForEach(vm.displayMangas) { manga in
                    NavigationLink(value: manga) {
                        MangaCoverView(
                            coverURL: manga.mainPicture,
                            namespace: namespace,
                            big: false
                        )
                    }
                    .buttonStyle(.plain)
                }

                // Paginación infinita (solo si NO está buscando)
                if vm.search.isEmpty && vm.canLoadMore {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .onAppear {
                            Task {
                                await vm.loadNextPage()
                            }
                        }
                }
            }
            .safeAreaPadding()
        }
    }

    // MARK: - Empty State
    private var emptyStateView: some View {
        Group {
            if vm.search.isEmpty {
                ContentUnavailableView(
                    "Explora el catálogo",
                    systemImage: "square.grid.2x2",
                    description: Text("Busca mangas o aplica filtros para explorar."))
            } else if vm.search.count <= 2 {
                ContentUnavailableView(
                    "Sigue escribiendo",
                    systemImage: "keyboard",
                    description: Text("Escribe al menos 3 caracteres para buscar."))
            } else {
                ContentUnavailableView(
                    "Sin resultados",
                    systemImage: "book.closed",
                    description: Text("No se encontraron mangas con ese título."))
            }
        }
    }

    // MARK: - Filter Menu
    private var filterMenu: some View {
        Menu {
            // Botón para limpiar filtros
            if vm.selectedGenre != nil || vm.selectedDemographic != nil || vm.selectedTheme != nil {
                Button(role: .destructive) {
                    Task {
                        await vm.clearFilters()
                    }
                } label: {
                    Label("Limpiar filtros", systemImage: "xmark.circle")
                }
                Divider()
            }

            // SECCIÓN: Géneros
            Menu {
                ForEach(vm.genres, id: \.self) { genre in
                    Button {
                        Task {
                            await vm.filterByGenre(genre)
                        }
                    } label: {
                        HStack {
                            Text(genre)
                            Spacer()
                            if vm.selectedGenre == genre {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            } label: {
                Label("Género", systemImage: "star.fill")
            }

            // SECCIÓN: Demographics
            Menu {
                ForEach(vm.demographics, id: \.self) { demographic in
                    Button {
                        Task {
                            await vm.filterByDemographic(demographic)
                        }
                    } label: {
                        HStack {
                            Text(demographic)
                            Spacer()
                            if vm.selectedDemographic == demographic {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            } label: {
                Label("Demografía", systemImage: "person.2.fill")
            }

            // SECCIÓN: Themes
            Menu {
                ForEach(vm.themes, id: \.self) { theme in
                    Button {
                        Task {
                            await vm.filterByTheme(theme)
                        }
                    } label: {
                        HStack {
                            Text(theme)
                            Spacer()
                            if vm.selectedTheme == theme {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            } label: {
                Label("Tema", systemImage: "tag.fill")
            }

        } label: {
            Image(systemName: "line.3.horizontal.decrease.circle")
        }
    }
}

#Preview {
    ExploreView()
}
