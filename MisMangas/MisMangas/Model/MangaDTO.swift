//
//  MangaDTO.swift
//  MisMangas
//
//  Created by Juan Ferrera Sala on 21/12/25.
//

import Foundation

struct MangaDTO: Codable, Identifiable, Hashable {
    let id: Int
    let title: String
    let titleEnglish: String?
    let titleJapanese: String?
    let mainPicture: String
    let sypnosis: String?
    let background: String?
    let score: Double?
    let volumes: Int?
    let chapters: Int?
    let status: String
    let startDate: String?
    let endDate: String?
    let url: String
    let authors: [AuthorDTO]
    let genres: [GenreDTO]
    let themes: [ThemeDTO]
    let demographics: [DemographicDTO]
}
