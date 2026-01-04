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
        HStack(alignment: .top, spacing: 12) {
            // Portada
            MangaCoverView(
                coverURL: manga.mainPicture,
                namespace: namespace,
                big: false
            )
            
            // Información
            VStack(alignment: .leading, spacing: 8) {
                Text(manga.title)
                    .font(.headline)
                    .lineLimit(2)
                
                // Estadísticas
                statsSection
                
                Spacer()
                
                // Progress bar
                if let totalVolumes = manga.totalVolumes {
                    progressBarsSection(totalVolumes: totalVolumes)
                }
            }
        }
        .padding()
        .background(.thinMaterial, in: .rect(cornerRadius: 16))
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
    
    // MARK: - Progress Bar Section
    private func progressBarsSection(totalVolumes: Int) -> some View {
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
}

#Preview {
    CollectionCardView(manga: .dragonBallCollection)
        .padding()
}
