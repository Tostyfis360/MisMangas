//
//  MangaDetailView.swift
//  MisMangas
//
//  Created by Juan Ferrera Sala on 4/1/26.
//

import SwiftUI
import SwiftData

struct MangaDetailView: View {
    let manga: MangaDTO
    let namespace: Namespace.ID

    @Environment(\.modelContext) private var modelContext
    @Query private var userCollection: [UserMangaCollection]

    @State private var showingAddSheet = false

    // Verificar si el manga ya está en la colección
    private var isInCollection: Bool {
        userCollection.contains { $0.mangaId == manga.id }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Portada grande
                MangaCoverView(coverURL: manga.mainPicture, namespace: namespace, big: true)
                    .frame(maxWidth: .infinity, alignment: .trailing)

                // Título y año
                titleSection

                // Autores
                authorsSection

                // Sinopsis
                if let synopsis = manga.sypnosis {
                    synopsisSection(synopsis)
                }

                // Background info
                if let background = manga.background {
                    backgroundSection(background)
                }

                // Información adicional
                additionalInfoSection

                // Score con estrellas
                if let score = manga.score {
                    ScoreRatingView(score: score)
                        .frame(maxWidth: .infinity)
                        .padding(.top)
                }

                // Géneros
                genresSection

                // Themes
                themesSection

                // Demographics
                demographicsSection

                // Botón para añadir a colección
                addToCollectionButton
            }
        }
        .safeAreaPadding()
        .sheet(isPresented: $showingAddSheet) {
            AddToCollectionSheet(manga: manga)
        }
    }

    // MARK: - Title Section
    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .firstTextBaseline) {
                Text(manga.title)
                    .font(.largeTitle)
                    .bold()
                Spacer()
            }

            if let titleEnglish = manga.titleEnglish, titleEnglish != manga.title {
                Text(titleEnglish)
                    .font(.title3)
                    .foregroundStyle(.secondary)
            }

            if let titleJapanese = manga.titleJapanese {
                Text(titleJapanese)
                    .font(.title3)
                    .foregroundStyle(.secondary)
            }
        }
    }

    // MARK: - Authors Section
    private var authorsSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            ForEach(manga.authors) { author in
                HStack {
                    Text(author.fullName)
                        .font(.title2)
                        .foregroundStyle(.secondary)
                    Text("(\(author.role))")
                        .font(.subheadline)
                        .foregroundStyle(.tertiary)
                }
            }
        }
    }

    // MARK: - Synopsis Section
    private func synopsisSection(_ synopsis: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Sinopsis")
                .font(.headline)
            Text(synopsis)
                .font(.body)
                .foregroundStyle(.secondary)
        }
    }

    // MARK: - Background Section
    private func backgroundSection(_ background: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Información adicional")
                .font(.headline)
            Text(background)
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
    }

    // MARK: - Additional Info Section
    private var additionalInfoSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                if let volumes = manga.volumes {
                    Label("\(volumes) volúmenes", systemImage: "books.vertical.fill")
                        .font(.subheadline)
                }

                if let chapters = manga.chapters {
                    Label("\(chapters) capítulos", systemImage: "book.pages.fill")
                        .font(.subheadline)
                }
            }

            HStack {
                Label(manga.status.capitalized, systemImage: statusIcon)
                    .font(.subheadline)

                if let startDate = manga.startDate {
                    Text("• \(formatDate(startDate))")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }

    // MARK: - Genres Section
    private var genresSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            if !manga.genres.isEmpty {
                Text("Géneros")
                    .font(.headline)

                FlowLayout(spacing: 8) {
                    ForEach(manga.genres) { genre in
                        Text(genre.genre)
                            .font(.caption)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(.blue.opacity(0.2), in: .capsule)
                            .foregroundStyle(.blue)
                    }
                }
            }
        }
    }

    // MARK: - Themes Section
    private var themesSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            if !manga.themes.isEmpty {
                Text("Temas")
                    .font(.headline)

                FlowLayout(spacing: 8) {
                    ForEach(manga.themes) { theme in
                        Text(theme.theme)
                            .font(.caption)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(.purple.opacity(0.2), in: .capsule)
                            .foregroundStyle(.purple)
                    }
                }
            }
        }
    }

    // MARK: - Demographics Section
    private var demographicsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            if !manga.demographics.isEmpty {
                Text("Demografía")
                    .font(.headline)

                FlowLayout(spacing: 8) {
                    ForEach(manga.demographics) { demographic in
                        Text(demographic.demographic)
                            .font(.caption)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(.green.opacity(0.2), in: .capsule)
                            .foregroundStyle(.green)
                    }
                }
            }
        }
    }

    // MARK: - Add to Collection Button
    private var addToCollectionButton: some View {
        Button {
            showingAddSheet = true
        } label: {
            Label(
                isInCollection ? "Editar en mi colección" : "Añadir a mi colección",
                systemImage: isInCollection ? "checkmark.circle.fill" : "plus.circle.fill")
            .font(.headline)
            .frame(maxWidth: .infinity)
            .padding()
            .background(isInCollection ? .green : .blue, in: .rect(cornerRadius: 12))
            .foregroundStyle(.white)
        }
        .padding(.top)
    }

    // MARK: - Helpers
    private var statusIcon: String {
        switch manga.status.lowercased() {
        case "finished": return "checkmark.circle.fill"
        case "publishing", "currently_publishing": return "arrow.clockwise.circle.fill"
        case "on_hiatus": return "pause.circle.fill"
        case "discontinued": return "xmark.circle.fill"
        default: return "circle.fill"
        }
    }

    private func formatDate(_ dateString: String) -> String {
        let formatter = ISO8601DateFormatter()
        guard let date = formatter.date(from: dateString) else { return dateString }

        let displayFormatter = DateFormatter()
        displayFormatter.dateStyle = .medium
        displayFormatter.timeStyle = .none
        return displayFormatter.string(from: date)
    }
}

// MARK: - Flow Layout
struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(in: proposal.replacingUnspecifiedDimensions().width, subviews: subviews, spacing: spacing)
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(in: bounds.width, subviews: subviews, spacing: spacing)
        for (index, subview) in subviews.enumerated() {
            subview.place(at: CGPoint(x: bounds.minX + result.positions[index].x, y: bounds.minY + result.positions[index].y), proposal: .unspecified)
        }
    }

    struct FlowResult {
        var size: CGSize = .zero
        var positions: [CGPoint] = []

        init(in maxWidth: CGFloat, subviews: Subviews, spacing: CGFloat) {
            var x: CGFloat = 0
            var y: CGFloat = 0
            var lineHeight: CGFloat = 0

            for subview in subviews {
                let size = subview.sizeThatFits(.unspecified)

                if x + size.width > maxWidth && x > 0 {
                    x = 0
                    y += lineHeight + spacing
                    lineHeight = 0
                }

                positions.append(CGPoint(x: x, y: y))
                lineHeight = max(lineHeight, size.height)
                x += size.width + spacing
            }

            self.size = CGSize(width: maxWidth, height: y + lineHeight)
        }
    }
}

// MARK: - Temporary Add Sheet (SPRINT 6)
struct AddToCollectionSheet: View {
    let manga: MangaDTO
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack {
                Text("Formulario para añadir a colección")
                    .font(.title2)
                Text("(Implementaremos en SPRINT 6)")
                    .foregroundStyle(.secondary)

                Spacer()
            }
            .padding()
            .navigationTitle("Añadir a colección")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    @Previewable @Namespace var namespace
    NavigationStack {
        MangaDetailView(manga: .dragonBall, namespace: namespace)
    }
    .modelContainer(for: UserMangaCollection.self, inMemory: true)
}
