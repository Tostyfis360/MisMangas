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

    // MARK: - Authentication
    func createUser(request: CreateUserRequest) async throws(NetworkError) {
        try await postVoid(.post(url: .createUser), body: request)
    }

    func loginJWT(email: String, password: String) async throws(NetworkError) -> JWTResponse {
        try await postJSON(.post(url: .loginJWT, email: email, password: password), type: JWTResponse.self)
    }

    func getUserInfo(token: String) async throws(NetworkError) -> UserInfo {
        var request = URLRequest.get(url: .getUserInfo)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return try await getJSON(request, type: UserInfo.self)
    }

    func refreshJWT(token: String) async throws(NetworkError) -> JWTResponse {
        try await postJSON(.post(url: .refreshJWT, token: token), type: JWTResponse.self)
    }

    // MARK: - Collection
    func addToCollection(token: String, mangaId: Int, data: CollectionUpdateRequest) async throws(NetworkError) {
        let body = CollectionRequest(mangaId: mangaId, data: data)
        try await postVoid(.post(url: .collection, token: token), body: body)
    }

    func getCollection(token: String) async throws(NetworkError) -> [CloudMangaCollection] {
        var request = URLRequest.get(url: .collection)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return try await getJSON(request, type: [CloudMangaCollection].self)
    }

    func deleteFromCollection(token: String, mangaId: Int) async throws(NetworkError) {
        try await deleteVoid(.delete(url: .collectionManga(id: mangaId), token: token))
    }
}
