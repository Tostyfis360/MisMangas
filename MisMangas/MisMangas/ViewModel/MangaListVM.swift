//
//  MangaListVM.swift
//  MisMangas
//
//  Created by Juan Ferrera Sala on 21/12/25.
//

import SwiftUI

@Observable
final class MangaListVM {
    let network = NetworkRepository()

    var mangas: [MangaDTO] = []
    var genres: [String] = []
    var demographics: [String] = []
    var themes: [String] = []

    var selectedGenre: String?
    var selectedDemographic: String?
    var selectedTheme: String?

    var isLoading = false
    var errorMessage: String?

    private var currentPage = 1
    private let itemsPerPage = 20
    var totalMangas = 0
    var canLoadMore = true

    // MARK: - Active Filter Type
    enum FilterType {
        case none
        case genre(String)
        case demographic(String)
        case theme(String)
    }

    var activeFilter: FilterType {
        if let genre = selectedGenre {
            return .genre(genre)
        } else if let demographic = selectedDemographic {
            return .demographic(demographic)
        } else if let theme = selectedTheme {
            return .theme(theme)
        }
        return .none
    }
    
    // MARK: - Load Initial Data
    func loadInitialData() async {
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil
        currentPage = 1
        mangas = []

        do {
            let mangasResult = try await network.fetchMangas(page: currentPage, per: itemsPerPage)
            let genresResult = try await network.fetchGenres()
            let demographicsResult = try await network.fetchDemographics()
            let themesResult = try await network.fetchThemes()

            self.mangas = mangasResult.items
            self.totalMangas = mangasResult.metadata.total
            self.genres = genresResult.sorted()
            self.demographics = demographicsResult.sorted()
            self.themes = themesResult.sorted()
            self.canLoadMore = mangas.count < totalMangas
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    // MARK: - Load Next Page
    func loadNextPage() async {
        guard !isLoading, canLoadMore else { return }
        isLoading = true
        currentPage += 1
        do {
            let response = try await fetchMangas(for: activeFilter, page: currentPage)
            mangas.append(contentsOf: response.items)
            canLoadMore = mangas.count < response.metadata.total
        } catch {
            errorMessage = error.localizedDescription
            currentPage -= 1
        }
        isLoading = false
    }

    // MARK: - Apply Filter
    func applyFilter(_ filter: FilterType) async {
        guard !isLoading else { return }

        selectedGenre = nil
        selectedDemographic = nil
        selectedTheme = nil

        switch filter {
        case .genre(let value): selectedGenre = value
        case .demographic(let value): selectedDemographic = value
        case .theme(let value): selectedTheme = value
        case .none: break
        }

        isLoading = true
        errorMessage = nil
        currentPage = 1
        mangas = []

        do {
            let response = try await fetchMangas(for: filter, page: currentPage)
            self.mangas = response.items
            self.totalMangas = response.metadata.total
            self.canLoadMore = mangas.count < totalMangas
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    // MARK: - Fetch centralizado
    private func fetchMangas(for filter: FilterType, page: Int) async throws -> PaginatedResponse<MangaDTO> {
        switch filter {
        case .genre(let genre):
            try await network.fetchMangas(byGenre: genre, page: page, per: itemsPerPage)
        case .demographic(let demographic):
            try await network.fetchMangas(byDemographic: demographic, page: page, per: itemsPerPage)
        case .theme(let theme):
            try await network.fetchMangas(byTheme: theme, page: page, per: itemsPerPage)
        case .none:
            try await network.fetchMangas(page: page, per: itemsPerPage)
        }
    }
}
