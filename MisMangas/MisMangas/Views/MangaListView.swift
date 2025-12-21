//
//  MangaListView.swift
//  MisMangas
//
//  Created by Juan Ferrera Sala on 21/12/25.
//

import SwiftUI

@MainActor let isiPhone = UIDevice.current.userInterfaceIdiom == .phone

struct MangaListView: View {
    @State private var vm = MangaListVM()
    @Namespace private var namespace
    
    // Grid para iPad
    private let gridColumns = [
        GridItem(.adaptive(minimum: 300), spacing: 16)
    ]
    
    var body: some View {
        NavigationStack {
            Group {
                if vm.mangas.isEmpty && !vm.isLoading {
                    ContentUnavailableView(
                        "No hay mangas",
                        systemImage: "book.closed",
                        description: Text("Desliza hacia abajo para recargar")
                    )
                } else {
                    mangaList
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Mangas")
                        .font(.title3)
                        .bold()
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    genreMenu
                }
            }
            .toolbarRole(.editor)
            .refreshable {
                await vm.loadInitialData()
            }
        }
        .task {
            if vm.mangas.isEmpty {
                await vm.loadInitialData()
            }
        }
        .alert("Error", isPresented: .constant(vm.errorMessage != nil)) {
            Button("OK") { vm.errorMessage = nil }
        } message: {
            if let error = vm.errorMessage {
                Text(error)
            }
        }
    }
    
    // MARK: - Manga List
    @ViewBuilder
    private var mangaList: some View {
        ScrollView {
            if isiPhone {
                // iPhone: Lista vertical
                LazyVStack(spacing: 12) {
                    mangaItems
                }
                .safeAreaPadding()
            } else {
                // iPad: Grid
                LazyVGrid(columns: gridColumns, spacing: 16) {
                    mangaItems
                }
                .safeAreaPadding()
            }
        }
    }
    
    // MARK: - Manga Items
    @ViewBuilder
    private var mangaItems: some View {
        ForEach(vm.mangas) { manga in
            NavigationLink(value: manga) {
                MangaCardView(manga: manga, namespace: namespace)
            }
            .buttonStyle(.plain)
        }
        
        // Scroll infinito
        if !vm.mangas.isEmpty && vm.canLoadMore {
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
    
    // MARK: - Genre Filter Menu
    private var genreMenu: some View {
        Menu {
            Button {
                Task {
                    await vm.filterByGenre(nil)
                }
            } label: {
                HStack {
                    Text("Todos")
                    Spacer()
                    if vm.selectedGenre == nil {
                        Image(systemName: "checkmark")
                    }
                }
            }
            
            Divider()
            
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
            Image(systemName: "line.3.horizontal.decrease.circle")
        }
    }
}

#Preview {
    MangaListView()
}
