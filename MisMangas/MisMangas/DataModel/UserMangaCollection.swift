//
//  UserMangaCollection.swift
//  MisMangas
//
//  Created by Juan Ferrera Sala on 21/12/25.
//

import Foundation
import SwiftData

@Model
final class UserMangaCollection {
    // MARK: - Índices para búsquedas eficientes
    #Index<UserMangaCollection>([\.title], [\.mangaId])

    // MARK: - Identificador único
    @Attribute(.unique) var mangaId: Int

    // MARK: - Información básica del manga
    var title: String
    var mainPicture: String
    var totalVolumes: Int?

    // MARK: - Datos de la colección del usuario
    var volumesOwned: Int
    var readingVolume: Int?
    var completeCollection: Bool

    // MARK: - Metadata
    var dateAdded: Date
    var lastUpdated: Date

    // MARK: - Inicializador
    init(
        mangaId: Int,
        title: String,
        mainPicture: String,
        totalVolumes: Int?,
        volumesOwned: Int = 0,
        readingVolume: Int? = nil,
        completeCollection: Bool = false) {
        self.mangaId = mangaId
        self.title = title
        self.mainPicture = mainPicture
        self.totalVolumes = totalVolumes
        self.volumesOwned = volumesOwned
        self.readingVolume = readingVolume
        self.completeCollection = completeCollection
        self.dateAdded = Date()
        self.lastUpdated = Date()
    }
}

// MARK: - Helper Computed Properties
extension UserMangaCollection {
    var readingProgress: Double? {
        guard let totalVolumes, totalVolumes > 0 else { return nil }
        let currentVolume = readingVolume ?? 0
        return Double(currentVolume) / Double(totalVolumes)
    }

    var collectionProgress: Double? {
        guard let totalVolumes, totalVolumes > 0 else { return nil }
        return Double(volumesOwned) / Double(totalVolumes)
    }

    var volumesOwnedS: String {
        guard let totalVolumes else { return "\(volumesOwned)" }
        return "\(volumesOwned)/\(totalVolumes)"
    }
}
