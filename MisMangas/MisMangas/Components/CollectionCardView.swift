//
//  CollectionCardView.swift
//  MisMangas
//
//  Created by Juan Ferrera Sala on 4/1/26.
//

import SwiftUI

struct CollectionCardView: View {
    let manga: UserMangaCollection
    @Namespace private var namespace

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            // Portada
            MangaCoverView(
                coverURL: manga.mainPicture,
                namespace: namespace,
                big: false)

            // Información
            VStack(alignment: .leading, spacing: 12) {
                // Título y stats
                VStack(alignment: .leading, spacing: 8) {
                    Text(manga.title)
                        .font(.headline)
                        .lineLimit(2)
                    statsSection
                }

                Spacer(minLength: 0)
                // Progress bars
                progressSection
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.ultraThinMaterial, in: .rect(cornerRadius: 16))
    }

    // MARK: - Stats Section
    private var statsSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 12) {
                Label("\(manga.volumesOwned)", systemImage: "book.fill")
                    .font(.caption)
                    .foregroundStyle(.blue)

                if let reading = manga.readingVolume {
                    Label("Leyendo: \(reading)", systemImage: "bookmark.fill")
                        .font(.caption)
                        .foregroundStyle(.orange)
                }
            }

            if manga.completeCollection {
                Label("Colección completa", systemImage: "checkmark.circle.fill")
                    .font(.caption)
                    .foregroundStyle(.green)
            }
        }
    }


    // MARK: - Progress Section
    private var progressSection: some View {
        VStack(spacing: 8) {
            if let totalVolumes = manga.totalVolumes {
                // Manga con los volúmenes conocidos
                progressBarsWithTotal(totalVolumes: totalVolumes)
            } else {
                // Manga en emisión se usa cuando el total no es conocido
                progressBarsOngoing
            }
        }
    }
    
    private func progressBarsWithTotal(totalVolumes: Int) -> some View {
        VStack(spacing: 8) {
            // Progreso de colección
            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    Text("Colección")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text(manga.volumesOwnedS)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }

                ProgressView(value: manga.collectionProgress ?? 0)
                    .tint(manga.completeCollection ? .green : .blue)
            }

            // Progreso de lectura
            if let readingProgress = manga.readingProgress, readingProgress > 0 {
                VStack(alignment: .leading, spacing: 2) {
                    HStack {
                        Text("Lectura")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                        Spacer()
                        if let reading = manga.readingVolume {
                            Text("\(reading)/\(totalVolumes)")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                    }
                    
                    ProgressView(value: readingProgress)
                        .tint(.orange)
                }
            }
        }
    }
    
    private var progressBarsOngoing: some View {
        VStack(spacing: 8) {
            // Info de volúmenes sin barra de progreso
            HStack {
                Label("\(manga.volumesOwned) tomos", systemImage: "books.vertical.fill")
                    .font(.caption)
                    .foregroundStyle(.blue)
                
                Spacer()

                if let reading = manga.readingVolume {
                    Label("Tomo \(reading)", systemImage: "bookmark.fill")
                        .font(.caption)
                        .foregroundStyle(.orange)
                }
            }
            .padding(.vertical, 4)

            // Indicador de serie en emisión
            HStack {
                Image(systemName: "antenna.radiowaves.left.and.right")
                    .font(.caption2)
                Text("En emisión")
                    .font(.caption2)
                Spacer()
            }
            .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    CollectionCardView(manga: .dragonBallCollection)
        .padding()
}
