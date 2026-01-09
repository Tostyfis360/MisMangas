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
    var isClickable: Bool = true

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Título de la sección
            if isClickable {
                // Clickable con la propiedad NavigationLink
                NavigationLink(value: CategoryNavigation(title: title, mangas: mangas)) {
                    titleContent
                }
                .buttonStyle(.plain)
            } else {
                // No clickable sin la propiedad NavigationLink
                HStack {
                    Text(title)
                        .font(.title2)
                        .bold()
                    Spacer()
                }
                .padding(.horizontal)
            }
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
    // MARK: - Title Content
    private var titleContent: some View {
        HStack {
            Text(title)
                .font(.title2)
                .bold()
                .foregroundStyle(.primary)
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundStyle(.secondary)
                .font(.subheadline)
        }
        .padding(.horizontal)
    }
}

// MARK: - Category Navigation
struct CategoryNavigation: Hashable {
    let title: String
    let mangas: [MangaDTO]
    
    var filterType: CategoryFilterType {
        // Determinar si el género o demografía por el título
        let demographics = ["Shounen", "Seinen", "Shoujo", "Josei", "Kids"]
        return demographics.contains(title) ? .demographic : .genre
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
