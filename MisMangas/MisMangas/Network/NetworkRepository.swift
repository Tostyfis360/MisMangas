//
//  NetworkRepository.swift
//  MisMangas
//
//  Created by Juan Ferrera Sala on 21/12/25.
//

import Foundation

struct NetworkRepository: NetworkInteractor {
    // MARK: - Fetch Mangas (Paginado con items + metadata)
    func fetchMangas(page: Int = 1, per: Int = 10) async throws(NetworkError) -> PaginatedResponse<MangaDTO> {
        try await getJSON(.get(url: .mangas(page: page, per: per)), type: PaginatedResponse<MangaDTO>.self)
    }

    // MARK: - Fetch Genres (array de strings)
    func fetchGenres() async throws(NetworkError) -> [String] {
        try await getJSON(.get(url: .genres), type: [String].self)
    }

    // MARK: - Fetch Demographics (array de strings)
    func fetchDemographics() async throws(NetworkError) -> [String] {
        try await getJSON(.get(url: .demographics), type: [String].self)
    }

    // MARK: - Fetch Themes (array de strings)
    func fetchThemes() async throws(NetworkError) -> [String] {
        try await getJSON(.get(url: .themes), type: [String].self)
    }

    // MARK: - Fetch Mangas by Genre (Paginado)
    func fetchMangas(byGenre genre: String, page: Int = 1, per: Int = 10) async throws(NetworkError) -> PaginatedResponse<MangaDTO> {
        try await getJSON(.get(url: .mangasByGenre(genre, page: page, per: per)), type: PaginatedResponse<MangaDTO>.self)
    }

    // MARK: - Fetch Mangas by Demographic (Paginado)
    func fetchMangas(byDemographic demographic: String, page: Int = 1, per: Int = 10) async throws(NetworkError) -> PaginatedResponse<MangaDTO> {
        try await getJSON(.get(url: .mangasByDemographic(demographic, page: page, per: per)), type: PaginatedResponse<MangaDTO>.self)
    }

    // MARK: - Fetch Mangas by Theme (Paginado)
    func fetchMangas(byTheme theme: String, page: Int = 1, per: Int = 10) async throws(NetworkError) -> PaginatedResponse<MangaDTO> {
        try await getJSON(.get(url: .mangasByTheme(theme, page: page, per: per)), type: PaginatedResponse<MangaDTO>.self)
    }

    // MARK: - Search Mangas (Begins With)
    func searchMangas(beginsWith text: String) async throws(NetworkError) -> [MangaDTO] {
        try await getJSON(.get(url: .searchMangasBeginsWith(text)), type: [MangaDTO].self)
    }

    // MARK: - Search Mangas (Contains)
    func searchMangas(contains text: String) async throws(NetworkError) -> [MangaDTO] {
        try await getJSON(.get(url: .searchMangasContains(text)), type: [MangaDTO].self)
    }

    // MARK: - Fetch Manga by ID
    func fetchManga(byID id: Int) async throws(NetworkError) -> MangaDTO {
        try await getJSON(.get(url: .mangaByID(id)), type: MangaDTO.self)
    }
}
