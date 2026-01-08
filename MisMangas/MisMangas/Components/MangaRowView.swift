//
//  MangaRowView.swift
//  MisMangas
//
//  Created by Juan Ferrera Sala on 8/1/26.
//

import SwiftUI

struct MangaRowView: View {
    let title: String
    let mangas: [MangaDTO]
    let namespace: Namespace.ID

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Título de la sección
            HStack {
                Text(title)
                    .font(.title2)
                    .bold()
                Spacer()
                // Flecha opcional
                Image(systemName: "chevron.right")
                    .foregroundStyle(.secondary)
                    .font(.subheadline)
            }
            .padding(.horizontal)
            // Scroll horizontal de portadas
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 16) {
                    ForEach(mangas.prefix(10)) { manga in
                        NavigationLink(value: manga) {
                            MangaCoverView(
                                coverURL: manga.mainPicture,
                                namespace: namespace,
                                big: false
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

#Preview {
    @Previewable @Namespace var namespace
    NavigationStack {
        MangaRowView(
            title: "Action",
            mangas: [.dragonBall, .onePiece, .naruto, .dragonBall, .onePiece],
            namespace: namespace
        )
    }
}
