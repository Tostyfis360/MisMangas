//
//  PreviewData.swift
//  MisMangas
//
//  Created by Juan Ferrera Sala on 21/12/25.
//

import Foundation
import SwiftData

// MARK: - MangaDTO Preview Data
extension MangaDTO {
    @MainActor static let dragonBall = MangaDTO(
        id: 42,
        title: "Dragon Ball",
        titleEnglish: "Dragon Ball",
        titleJapanese: "ドラゴンボール",
        mainPicture: "https://cdn.myanimelist.net/images/manga/3/54525.jpg",
        sypnosis: "Bulma, a headstrong girl, is on a quest to find the seven Dragon Balls...",
        background: "Dragon Ball has become one of the most successful manga series...",
        score: 8.41,
        volumes: 42,
        chapters: 520,
        status: "finished",
        startDate: "1984-11-20T00:00:00Z",
        endDate: "1995-05-23T00:00:00Z",
        url: "https://myanimelist.net/manga/42/Dragon_Ball",
        authors: [AuthorDTO.akira],
        genres: [GenreDTO.action],
        themes: [ThemeDTO.martialArts],
        demographics: [DemographicDTO.shounen]
    )
    
    @MainActor static let onePiece = MangaDTO(
        id: 13,
        title: "One Piece",
        titleEnglish: "One Piece",
        titleJapanese: "ONE PIECE",
        mainPicture: "https://cdn.myanimelist.net/images/manga/2/253146.jpg",
        sypnosis: "Gol D. Roger, a man referred to as the King of the Pirates...",
        background: "One Piece is the best-selling manga series of all time...",
        score: 9.21,
        volumes: nil,
        chapters: nil,
        status: "publishing",
        startDate: "1997-07-22T00:00:00Z",
        endDate: nil,
        url: "https://myanimelist.net/manga/13/One_Piece",
        authors: [AuthorDTO.oda],
        genres: [GenreDTO.action, GenreDTO.adventure],
        themes: [ThemeDTO.pirates],
        demographics: [DemographicDTO.shounen]
    )
    
    @MainActor static let naruto = MangaDTO(
        id: 11,
        title: "Naruto",
        titleEnglish: "Naruto",
        titleJapanese: "NARUTO -ナルト-",
        mainPicture: "https://cdn.myanimelist.net/images/manga/3/249658.jpg",
        sypnosis: "Naruto Uzumaki is a young ninja who bears a great power hidden inside him...",
        background: "Naruto was serialized in Weekly Shounen Jump...",
        score: 8.15,
        volumes: 72,
        chapters: 700,
        status: "finished",
        startDate: "1999-09-21T00:00:00Z",
        endDate: "2014-11-10T00:00:00Z",
        url: "https://myanimelist.net/manga/11/Naruto",
        authors: [AuthorDTO.kishimoto],
        genres: [GenreDTO.action],
        themes: [ThemeDTO.martialArts],
        demographics: [DemographicDTO.shounen]
    )
    
    @MainActor static let sampleMangas: [MangaDTO] = [
        dragonBall,
        onePiece,
        naruto
    ]
}

// MARK: - AuthorDTO Preview Data
extension AuthorDTO {
    @MainActor static let akira = AuthorDTO(
        id: "998C1B16-E3DB-47D1-8157-8389B5345D03",
        firstName: "Akira",
        lastName: "Toriyama",
        role: "Story & Art"
    )
    
    @MainActor static let oda = AuthorDTO(
        id: "F6396B2F-8C1A-4F48-9308-E88F3C1B3C8E",
        firstName: "Eiichiro",
        lastName: "Oda",
        role: "Story & Art"
    )
    
    @MainActor static let kishimoto = AuthorDTO(
        id: "A3C5E8D9-7B4F-4E2A-9F1D-2C8A6B5D4E3F",
        firstName: "Masashi",
        lastName: "Kishimoto",
        role: "Story & Art"
    )
}

// MARK: - GenreDTO Preview Data
extension GenreDTO {
    @MainActor static let action = GenreDTO(
        id: "72C8E862-334F-4F00-B8EC-E1E4125BB7CD",
        genre: "Action"
    )
    
    @MainActor static let adventure = GenreDTO(
        id: "A2D3E4F5-1234-5678-90AB-CDEF12345678",
        genre: "Adventure"
    )
}

// MARK: - ThemeDTO Preview Data
extension ThemeDTO {
    @MainActor static let martialArts = ThemeDTO(
        id: "ADC7CBC8-36B9-4E52-924A-4272B7B2CB2C",
        theme: "Martial Arts"
    )
    
    @MainActor static let pirates = ThemeDTO(
        id: "B3E4F5A6-5678-90AB-CDEF-123456789ABC",
        theme: "Pirates"
    )
}

// MARK: - DemographicDTO Preview Data
extension DemographicDTO {
    @MainActor static let shounen = DemographicDTO(
        id: "5E05BBF1-A72E-4231-9487-71CFE508F9F9",
        demographic: "Shounen"
    )
}

// MARK: - UserMangaCollection Preview Data
extension UserMangaCollection {
    @MainActor static let dragonBallCollection = UserMangaCollection(
        mangaId: 42,
        title: "Dragon Ball",
        mainPicture: "https://cdn.myanimelist.net/images/manga/3/54525.jpg",
        totalVolumes: 42,
        volumesOwned: 30,
        readingVolume: 25,
        completeCollection: false
    )
    
    @MainActor static let onePieceCollection = UserMangaCollection(
        mangaId: 13,
        title: "One Piece",
        mainPicture: "https://cdn.myanimelist.net/images/manga/2/253146.jpg",
        totalVolumes: 108,
        volumesOwned: 108,
        readingVolume: 100,
        completeCollection: true
    )
    
    @MainActor static let sampleCollections: [UserMangaCollection] = [
        dragonBallCollection,
        onePieceCollection
    ]
}
