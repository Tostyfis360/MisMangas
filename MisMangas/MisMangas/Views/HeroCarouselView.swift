//
//  HeroCarouselView.swift
//  MisMangas
//
//  Created by Juan Ferrera Sala on 8/1/26.
//

import SwiftUI

struct HeroCarouselView: View {
    let mangas: [MangaDTO]
    let namespace: Namespace.ID

    @State private var currentIndex = 0
    private var heroHeight: CGFloat {
        isiPhone ? 600 : 700  // iPhone: 600pt , iPad: 700pt
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            // Carrusel de imágenes
            TabView(selection: $currentIndex) {
                ForEach(Array(mangas.prefix(5).enumerated()), id: \.element.id) { index, manga in
                    heroImage(for: manga)
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: heroHeight)
            .ignoresSafeArea(edges: .top)

            // Gradiente inferior
            LinearGradient(
                colors: [
                    .clear,
                    .clear,
                    Color(.systemBackground).opacity(0.1),
                    Color(.systemBackground).opacity(0.3),
                    Color(.systemBackground).opacity(0.6),
                    Color(.systemBackground).opacity(0.85),
                    Color(.systemBackground)
                ],
                startPoint: .top,
                endPoint: .bottom)
            .frame(height: 250)

            // Información del manga actual
            if !mangas.isEmpty, currentIndex < mangas.count {
                mangaInfo(for: mangas[currentIndex])
                    .padding(.bottom, 40)
            }

            // Indicadores de página
            pageIndicators
                .padding(.bottom, 10)
        }
        .frame(height: heroHeight)
        .task {
            let mangaCount = min(mangas.count, 5)
            guard mangaCount > 1 else { return }
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(5))
                guard !Task.isCancelled else { return }
                withAnimation {
                    currentIndex = (currentIndex + 1) % mangaCount
                }
            }
        }
    }

    // MARK: - Hero Image
    private func heroImage(for manga: MangaDTO) -> some View {
        AsyncImage(url: URL(string: manga.mainPicture.replacingOccurrences(of: "\"", with: ""))) { image in
            image
                .resizable()
                .scaledToFill()
        } placeholder: {
            Rectangle()
                .fill(.gray.opacity(0.3))
        }
        .frame(height: heroHeight)
        .frame(maxWidth: .infinity)
        .clipped()
    }

    // MARK: - Manga Info
    private func mangaInfo(for manga: MangaDTO) -> some View {
        VStack(spacing: 12) {
            // Título
            Text(manga.title)
                .font(.title)
                .bold()
                .multilineTextAlignment(.center)
                .lineLimit(2)

            // Categorías
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
            .font(.body)

            NavigationLink(value: manga) {
                Text("Ver detalle")
                    .font(.headline)
                    .padding()
                    .glassEffect(.regular.interactive())
                    .foregroundStyle(.white)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal)
    }

    // MARK: - Page Indicators
    private var pageIndicators: some View {
        HStack(spacing: 8) {
            ForEach(0..<min(mangas.count, 5), id: \.self) { index in
                Circle()
                    .fill(currentIndex == index ? Color.white : Color.white.opacity(0.5))
                    .frame(width: 8, height: 8)
                    .animation(.easeInOut, value: currentIndex)
            }
        }
    }
}

#Preview {
    @Previewable @Namespace var namespace
    NavigationStack {
        HeroCarouselView(
            mangas: [.dragonBall, .onePiece, .naruto],
            namespace: namespace)
    }
}
