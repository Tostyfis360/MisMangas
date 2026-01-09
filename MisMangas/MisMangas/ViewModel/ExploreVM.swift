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
            let response: PaginatedResponse<MangaDTO>
            if let genre = selectedGenre {
                response = try await network.fetchMangas(byGenre: genre, page: currentPage, per: itemsPerPage)
            } else if let demographic = selectedDemographic {
                response = try await network.fetchMangas(byDemographic: demographic, page: currentPage, per: itemsPerPage)
            } else if let theme = selectedTheme {
                response = try await network.fetchMangas(byTheme: theme, page: currentPage, per: itemsPerPage)
            } else {
                response = try await network.fetchMangas(page: currentPage, per: itemsPerPage)
            }
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

    // MARK: - Filter by Genre
    func filterByGenre(_ genre: String?) async {
        selectedDemographic = nil
        selectedTheme = nil
        selectedGenre = genre
        await reloadMangas()
    }

    // MARK: - Filter by Demographic
    func filterByDemographic(_ demographic: String?) async {
        selectedGenre = nil
        selectedTheme = nil
        selectedDemographic = demographic
        await reloadMangas()
    }

    // MARK: - Filter by Theme
    func filterByTheme(_ theme: String?) async {
        selectedGenre = nil
        selectedDemographic = nil
        selectedTheme = theme
        await reloadMangas()
    }

    // MARK: - Clear Filters
    func clearFilters() async {
        selectedGenre = nil
        selectedDemographic = nil
        selectedTheme = nil
        await reloadMangas()
    }

    // MARK: - Reload Mangas
    private func reloadMangas() async {
        currentPage = 1
        mangas = []
        do {
            let response: PaginatedResponse<MangaDTO>
            if let genre = selectedGenre {
                response = try await network.fetchMangas(byGenre: genre, page: currentPage, per: itemsPerPage)
            } else if let demographic = selectedDemographic {
                response = try await network.fetchMangas(byDemographic: demographic, page: currentPage, per: itemsPerPage)
            } else if let theme = selectedTheme {
                response = try await network.fetchMangas(byTheme: theme, page: currentPage, per: itemsPerPage)
            } else {
                response = try await network.fetchMangas(page: currentPage, per: itemsPerPage)
            }
            self.mangas = response.items
            self.canLoadMore = response.items.count == itemsPerPage
        } catch {
            print(error)
        }
    }
}
