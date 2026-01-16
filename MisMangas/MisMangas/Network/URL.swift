//
//  Url.swift
//  MisMangas
//
//  Created by Juan Ferrera Sala on 21/12/25.
//

import Foundation

let mangaAPI = URL(string: "https://mymanga-acacademy-5607149ebe3d.herokuapp.com")!

extension URL {
    // MARK: - List Endpoints
    static let allMangas = mangaAPI.appending(path: "/list/mangas")
    static let genres = mangaAPI.appending(path: "/list/genres")
    static let demographics = mangaAPI.appending(path: "/list/demographics")
    static let themes = mangaAPI.appending(path: "/list/themes")

    // MARK: - List by Category
    static func mangasByGenre(_ genre: String) -> URL {
        mangaAPI.appending(path: "/list/mangaByGenre").appending(path: genre)
    }

    static func mangasByDemographic(_ demographic: String) -> URL {
        mangaAPI.appending(path: "/list/mangaByDemographic").appending(path: demographic)
    }

    static func mangasByTheme(_ theme: String) -> URL {
        mangaAPI.appending(path: "/list/mangaByTheme").appending(path: theme)
    }

    // MARK: - Search Endpoints
    static func searchMangasBeginsWith(_ text: String) -> URL {
        mangaAPI.appending(path: "/search/mangasBeginsWith").appending(path: text)
    }

    static func searchMangasContains(_ text: String) -> URL {
        mangaAPI.appending(path: "/search/mangasContains").appending(path: text)
    }

    static func mangaByID(_ id: Int) -> URL {
        mangaAPI.appending(path: "/search/manga").appending(path: "\(id)")
    }

    // MARK: - Paginated Endpoints
    static func mangas(page: Int, per: Int = 10) -> URL {
        let url = mangaAPI.appending(path: "/list/mangas")
        let queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "per", value: "\(per)")]
        return url.appending(queryItems: queryItems)
    }

    static func mangasByGenre(_ genre: String, page: Int, per: Int = 10) -> URL {
        let url = mangasByGenre(genre)
        let queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "per", value: "\(per)")]
        return url.appending(queryItems: queryItems)
    }

    static func mangasByDemographic(_ demographic: String, page: Int, per: Int = 10) -> URL {
        let url = mangasByDemographic(demographic)
        let queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "per", value: "\(per)")]
        return url.appending(queryItems: queryItems)
    }

    static func mangasByTheme(_ theme: String, page: Int, per: Int = 10) -> URL {
        let url = mangasByTheme(theme)
        let queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "per", value: "\(per)")]
        return url.appending(queryItems: queryItems)
    }

    // MARK: - Authentication Endpoints
    static let createUser = mangaAPI.appending(path: "/users")
    static let loginJWT = mangaAPI.appending(path: "/users/jwt/login")
    static let getUserInfo = mangaAPI.appending(path: "/users/jwt/me")
    static let refreshJWT = mangaAPI.appending(path: "/users/jwt/refresh")

    // MARK: - Collection Endpoints
    static let collection = mangaAPI.appending(path: "/collection/manga")

    static func collectionManga(id: Int) -> URL {
        mangaAPI.appending(path: "/collection/manga").appending(path: "\(id)")
    }
}
