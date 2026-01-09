//
//  CollectionView.swift
//  MisMangas
//
//  Created by Juan Ferrera Sala on 4/1/26.
//

import SwiftUI
import SwiftData

struct CollectionView: View {
    @Query(sort: \UserMangaCollection.dateAdded, order: .reverse)
    private var userCollection: [UserMangaCollection]

    @Environment(\.modelContext) private var modelContext
    @State private var selectedManga: UserMangaCollection?
    @State private var showingEditSheet = false
    @State private var mangaToEdit: MangaDTO?

    // Grid para iPad
    private let gridColumns = [
        GridItem(.adaptive(minimum: 300), spacing: 16)]

    var body: some View {
        NavigationStack {
            Group {
                if userCollection.isEmpty {
                    emptyStateView
                } else {
                    collectionList
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Mi Colección")
                        .font(.title3)
                        .bold()
                }
            }
            .toolbarRole(.editor)
        }
        .sheet(item: $mangaToEdit) { manga in
            AddToCollectionSheet(manga: manga)
        }
    }

    // MARK: - Collection List
    @ViewBuilder
    private var collectionList: some View {
        ScrollView {
            if isiPhone {
                // iPhone: Lista vertical
                LazyVStack(spacing: 12) {
                    collectionItems
                }
                .safeAreaPadding()
            } else {
                // iPad: Grid
                LazyVGrid(columns: gridColumns, spacing: 16) {
                    collectionItems
                }
                .safeAreaPadding()
            }
        }
    }

    // MARK: - Collection Items
    @ViewBuilder
    private var collectionItems: some View {
        ForEach(userCollection) { manga in
            CollectionCardView(manga: manga)
                .onTapGesture {
                    editManga(manga)
                }
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    Button(role: .destructive) {
                        deleteManga(manga)
                    } label: {
                        Label("Eliminar", systemImage: "trash")
                    }
                }
                .contextMenu {
                    Button {
                        editManga(manga)
                    } label: {
                        Label("Editar", systemImage: "pencil")
                    }
                    
                    Button(role: .destructive) {
                        deleteManga(manga)
                    } label: {
                        Label("Eliminar", systemImage: "trash")
                    }
                }
        }
    }

    // MARK: - Empty State
    private var emptyStateView: some View {
        ContentUnavailableView {
            Label("Sin mangas", systemImage: "book.closed")
        } description: {
            Text("Añade mangas a tu colección desde el catálogo")
        }
    }

    // MARK: - Edit Manga
    private func editManga(_ manga: UserMangaCollection) {
        // Crear un MangaDTO básico para el sheet
        // Solo se necesita los campos que usa el sheet
        let mangaDTO = MangaDTO(
            id: manga.mangaId,
            title: manga.title,
            titleEnglish: nil,
            titleJapanese: nil,
            mainPicture: manga.mainPicture,
            sypnosis: nil,
            background: nil,
            score: nil,
            volumes: manga.totalVolumes,
            chapters: nil,
            status: "",
            startDate: nil,
            endDate: nil,
            url: "",
            authors: [],
            genres: [],
            themes: [],
            demographics: [])
        mangaToEdit = mangaDTO
    }

    // MARK: - Delete Manga
    private func deleteManga(_ manga: UserMangaCollection) {
        modelContext.delete(manga)
        
        do {
            try modelContext.save()
        } catch {
            print("Error al eliminar: \(error)")
        }
    }
}

#Preview {
    CollectionView()
        .modelContainer(for: UserMangaCollection.self, inMemory: true)
}
