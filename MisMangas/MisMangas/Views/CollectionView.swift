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

    // Manager para sincronizar
    @State private var syncManager = SyncManager()

    // Grid para iPad
    private let gridColumns = [GridItem(.adaptive(minimum: 300), spacing: 16)]

    // Info del usuario
    private var userEmail: String {
        AuthManager.shared.currentUser?.email ?? "Usuario"
    }

    // Iniciales para el avatar
    private var userInitials: String {
        let email = userEmail
        return String(email.prefix(1).uppercased())
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Header con perfil
                    profileHeader

                    // Colección
                    if userCollection.isEmpty {
                        emptyStateView
                            .padding(.top, 60)
                    } else {
                        collectionGrid
                    }
                }
                .safeAreaPadding()
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
    private var collectionGrid: some View {
        LazyVGrid(columns: isiPhone ? [GridItem(.flexible(), spacing: 16)] : [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)], spacing: 16) {
            collectionItems
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

    // MARK: - Profile Header
    private var profileHeader: some View {
        HStack(spacing: 16) {
            // Avatar con las iniciales
            ZStack {
                Circle()
                    .fill(LinearGradient(
                            colors: [.blue, .purple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing))
                    .frame(width: 60, height: 60)
                Text(userInitials)
                    .font(.title2)
                    .bold()
                    .foregroundStyle(.white)
            }
            // Info del usuario
            VStack(alignment: .leading, spacing: 4) {
                Text(userEmail)
                    .font(.headline)
                Text("\(userCollection.count) mangas en colección")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            // Botón de logout
            Button {
                logoutBtn()
            } label: {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                    .font(.title3)
                    .foregroundStyle(.red)
                    .padding(12)
                    .background(.thinMaterial, in: Circle())
            }
        }
        .padding()
        .background(.ultraThinMaterial, in: .rect(cornerRadius: 16))
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
        let mangaId = manga.mangaId

        // Eliminar de local
        modelContext.delete(manga)

        do {
            try modelContext.save()

            // Eliminar de la nube si está autenticado
            if AuthManager.shared.isAuthenticated {
                Task {
                    await syncManager.deleteFromCloud(mangaId: mangaId)
                }
            }

        } catch {
            print("Error al eliminar: \(error)")
        }
    }

    // MARK: - Logout
    private func logoutBtn() {
        // Limpiar colección en local
        for manga in userCollection {
            modelContext.delete(manga)
        }
        try? modelContext.save()
        // Logout
        AuthManager.shared.logout()
    }
}

#Preview {
    CollectionView()
        .modelContainer(for: UserMangaCollection.self, inMemory: true)
}
