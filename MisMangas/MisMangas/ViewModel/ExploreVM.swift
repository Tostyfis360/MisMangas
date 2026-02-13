//
// ExploreVM.swift
//  MisMangas
//
//  Created by Juan Ferrera Sala on 8/1/26.
//

import SwiftUI

@Observable
final class ExploreVM {
    let network = NetworkRepository()

    // Datos principales
    var mangas: [MangaDTO] = []
    var genres: [String] = []
    var demographics: [String] = []
    var themes: [String] = []

    // Búsqueda
    var search = ""
    var searchResults: [MangaDTO] = []

    // Filtros
    var selectedGenre: String?
    var selectedDemographic: String?
    var selectedTheme: String?

    // Paginación
    private var currentPage = 1
    private let itemsPerPage = 20
    var canLoadMore = true

    // MARK: - Filter Type
    enum FilterType {
        case none
        case genre(String)
        case demographic(String)
        case theme(String)
    }

    private var activeFilter: FilterType {
        if let genre = selectedGenre { return .genre(genre) }
        if let demographic = selectedDemographic { return .demographic(demographic) }
        if let theme = selectedTheme { return .theme(theme) }
        return .none
    }

    // MARK: - Display Mangas
    var displayMangas: [MangaDTO] {
        // Si está buscando, muestra resultados de la búsqueda
        if !search.isEmpty && search.count >= 3 {
            return searchResults
        }
        // Si no, muestra el catálogo con o sin los filtros
        return mangas
    }

    // MARK: - Load Initial Data
    func loadInitialData() async {
        currentPage = 1
        mangas = []

        do {
            let mangasResult = try await network.fetchMangas(page: currentPage, per: itemsPerPage)
            let genresResult = try await network.fetchGenres()
            let demographicsResult = try await network.fetchDemographics()
            let themesResult = try await network.fetchThemes()

            self.mangas = mangasResult.items
            self.genres = genresResult.sorted()
            self.demographics = demographicsResult.sorted()
            self.themes = themesResult.sorted()
            self.canLoadMore = mangasResult.items.count == itemsPerPage

        } catch {
            print(error)
        }
    }

    // MARK: - Load Next Page
    func loadNextPage() async {
        guard canLoadMore, search.isEmpty else { return }
        currentPage += 1
        do {
            let response = try await fetchMangas(for: activeFilter, page: currentPage)
            mangas.append(contentsOf: response.items)
            canLoadMore = response.items.count == itemsPerPage
        } catch {
            print(error)
            currentPage -= 1
        }
    }

    // MARK: - Search
    func findMangas() async {
        do {
            searchResults = try await network.searchMangas(beginsWith: search)
        } catch {
            print(error)
        }
    }

    // MARK: - Apply Filter
    func applyFilter(_ filter: FilterType) async {
        selectedGenre = nil
        selectedDemographic = nil
        selectedTheme = nil

        switch filter {
        case .genre(let value): selectedGenre = value
        case .demographic(let value): selectedDemographic = value
        case .theme(let value): selectedTheme = value
        case .none: break
        }

        currentPage = 1
        mangas = []
        do {
            let response = try await fetchMangas(for: filter, page: currentPage)
            self.mangas = response.items
            self.canLoadMore = response.items.count == itemsPerPage
        } catch {
            print(error)
        }
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
