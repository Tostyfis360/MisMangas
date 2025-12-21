//
//  MangaCardView.swift
//  MisMangas
//
//  Created by Juan Ferrera Sala on 21/12/25.
//

import SwiftUI

struct MangaCardView: View {
    let manga: MangaDTO
    let namespace: Namespace.ID
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            MangaCoverView(coverURL: manga.mainPicture, namespace: namespace)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(manga.title)
                    .font(.headline)
                    .lineLimit(2)
                
                if !manga.authors.isEmpty {
                    Text(manga.authors.map { $0.fullName }.joined(separator: ", "))
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
                
                if let synopsis = manga.sypnosis {
                    Text(synopsis)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(3)
                        .padding(.top, 2)
                }
                
                Spacer()
                
                HStack {
                    if let score = manga.score {
                        HStack(spacing: 2) {
                            Image(systemName: "star.fill")
                                .foregroundStyle(.yellow)
                                .font(.caption)
                            Text(score.formatted(.number.precision(.fractionLength(2))))
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    
                    Spacer()
                    
                    if let volumes = manga.volumes {
                        Text("\(volumes) vols")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.top, 4)
            }
        }
        .padding()
        .background(.thinMaterial, in: .rect(cornerRadius: 16))
    }
}

#Preview {
    @Previewable @Namespace var namespace
    MangaCardView(manga: .dragonBall, namespace: namespace)
        .padding()
}
