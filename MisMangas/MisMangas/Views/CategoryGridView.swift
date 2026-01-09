//
//  CategoryGridView.swift
//  MisMangas
//
//  Created by Juan Ferrera Sala on 9/1/26.
//

import SwiftUI

struct CategoryGridView: View {
    let category: String
    let filterType: CategoryFilterType

    @State private var vm = CategoryGridVM()
    @Namespace private var namespace

    // Grid columns
    private let gridColumns = [GridItem(.adaptive(minimum: isiPhone ? 110 : 180), spacing: 12)]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: gridColumns, spacing: 16) {
                ForEach(vm.mangas) { manga in
                    NavigationLink(value: manga) {
                        MangaCoverView(
                            coverURL: manga.mainPicture,
                            namespace: namespace,
                            big: false)
                    }
                    .buttonStyle(.plain)
                }
                // Paginación infinita
                if vm.canLoadMore {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .onAppear {
                            Task {
                                await vm.loadNextPage()
                            }
                        }
                }
            }
            .safeAreaPadding()
        }
        .navigationTitle(category)
        .navigationBarTitleDisplayMode(.large)
        .task {
            await vm.loadInitialData(category: category, filterType: filterType)
        }
    }
}

// MARK: - Filter Type Enum
enum CategoryFilterType {
    case genre
    case demographic
}

#Preview {
    NavigationStack {
        CategoryGridView(
            category: "Action",
            filterType: .genre
        )
    }
}
