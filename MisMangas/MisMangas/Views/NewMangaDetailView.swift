//
//  NewMangaDetailView.swift
//  MisMangas
//
//  Created by Juan Ferrera Sala on 8/1/26.
//

import SwiftUI
import SwiftData

struct NewMangaDetailView: View {
    let manga: MangaDTO
    let namespace: Namespace.ID

    @Environment(\.modelContext) private var modelContext
    @Query private var userCollection: [UserMangaCollection]

    @State private var showingAddSheet = false
    @State private var isExpanded = false

    private var isInCollection: Bool {
        userCollection.contains { $0.mangaId == manga.id }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Portada del manga en grande centrada
                heroSection
                // Todo el contenido
                contentSection
            }
        }
        .ignoresSafeArea(edges: .top)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showingAddSheet = true
                } label: {
                    Image(systemName: isInCollection ? "checkmark.circle.fill" : "plus.circle")
                        .font(.title3)
                        .foregroundStyle(isInCollection ? .green : .primary)
                }
            }
        }
        .sheet(isPresented: $showingAddSheet) {
            AddToCollectionSheet(manga: manga)
        }
    }

    // MARK: - Hero Section
    private var heroSection: some View {
        ZStack(alignment: .bottom) {
            AsyncImage(url: URL(string: manga.mainPicture.replacingOccurrences(of: "\"", with: ""))) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                Rectangle()
                    .fill(.gray.opacity(0.3))
            }
            .frame(height: 500)
            .frame(maxWidth: .infinity)
            .clipped()

            LinearGradient(
                colors: [
                    .clear,
                    .clear,
                    Color(.systemBackground).opacity(0.1),
                    Color(.systemBackground).opacity(0.3),
                    Color(.systemBackground).opacity(0.6),
                    Color(.systemBackground).opacity(0.85),
                    Color(.systemBackground)],
                startPoint: .top,
                endPoint: .bottom)
            .frame(height: 100)
        }
        .frame(height: 500)
    }

    // MARK: - Content Section
    private var contentSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Título
            Text(manga.title)
                .font(.largeTitle)
                .bold()
                .frame(maxWidth: .infinity, alignment: .center)

            // Categorías en línea
            categoriesLine
                .frame(maxWidth: .infinity, alignment: .center)

            // Botón principal
            addButton
                .frame(maxWidth: .infinity, alignment: .center)

            // Sinopsis expandible
            synopsisSection

            // Ficha Técnica
            technicalSheet
        }
        .padding()
    }

    // MARK: - Categories Line
    private var categoriesLine: some View {
        HStack(spacing: 4) {
            Text("Manga")
                .foregroundStyle(.secondary)

            if let demographic = manga.demographics.first {
                Text("•")
                    .foregroundStyle(.secondary)
                Text(demographic.demographic)
                    .foregroundStyle(.secondary)
            }

            if let genre = manga.genres.first {
                Text("•")
                    .foregroundStyle(.secondary)
                Text(genre.genre)
                    .foregroundStyle(.secondary)
            }
        }
        .font(.subheadline)
    }

    // MARK: - Add Button
    private var addButton: some View {
        Button {
            showingAddSheet = true
        } label: {
            Text(isInCollection ? "Editar en mi colección" : "Añadir a mi colección")
                .font(.headline)
                .padding()
                .glassEffect(.regular.interactive())
                .foregroundStyle(.white)
        }
    }

    // MARK: - Synopsis Section
    private var synopsisSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let synopsis = manga.sypnosis {
                Text(synopsis)
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .lineLimit(isExpanded ? nil : 3)
                Button {
                    withAnimation {
                        isExpanded.toggle()
                    }
                } label: {
                    Text(isExpanded ? "menos" : "más")
                        .font(.subheadline)
                        .bold()
                }
            }
        }
    }

    // MARK: - Technical Sheet
    private var technicalSheet: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("FICHA TÉCNICA")
                .font(.headline)
                .foregroundStyle(.secondary)

            // Autores
            if !manga.authors.isEmpty {
                technicalRow(
                    title: manga.authors.count == 1 ? "Autor" : "Autores",
                    value: manga.authors.map { "\($0.fullName) (\($0.role))" }.joined(separator: ", "))
            }

            // Volúmenes
            if let volumes = manga.volumes {
                technicalRow(title: "Volúmenes", value: "\(volumes)")
            }

            // Capítulos
            if let chapters = manga.chapters {
                technicalRow(title: "Capítulos", value: "\(chapters)")
            }

            // Estado
            technicalRow(title: "Estado", value: manga.status.capitalized.replacingOccurrences(of: "_", with: " "))

            // Fecha de inicio
            if let startDate = manga.startDate {
                technicalRow(title: "Estreno", value: formatDate(startDate))
            }

            // Puntuación
            if let score = manga.score {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Puntuación")
                        .font(.body)
                    ScoreRatingView(score: score)
                }
            }

            // Géneros
            if !manga.genres.isEmpty {
                technicalRow(
                    title: "Géneros",
                    value: manga.genres.map { $0.genre }.joined(separator: ", "))
            }

            // Temas
            if !manga.themes.isEmpty {
                technicalRow(
                    title: "Temas",
                    value: manga.themes.map { $0.theme }.joined(separator: ", "))
            }

            // Background
            if let background = manga.background {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Información adicional")
                        .font(.body)
                    Text(background)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }

    // MARK: - Technical Row Helper
    private func technicalRow(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.body)
            Text(value)
                .font(.body)
                .foregroundStyle(.secondary)
        }
    }

    // MARK: - Helper
    private func formatDate(_ dateString: String) -> String {
        let formatter = ISO8601DateFormatter()
        guard let date = formatter.date(from: dateString) else { return dateString }
        let displayFormatter = DateFormatter()
        displayFormatter.dateStyle = .medium
        displayFormatter.timeStyle = .none
        return displayFormatter.string(from: date)
    }
}

#Preview {
    @Previewable @Namespace var namespace
    NavigationStack {
        NewMangaDetailView(manga: .dragonBall, namespace: namespace)
    }
    .modelContainer(for: UserMangaCollection.self, inMemory: true)
}

