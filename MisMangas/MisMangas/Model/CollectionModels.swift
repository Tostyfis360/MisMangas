//
//  CollectionModels.swift
//  MisMangas
//
//  Created by Juan Ferrera Sala on 16/1/26.
//

import Foundation

// MARK: - Collection Request Models
// Datos que se envían para poder actualizar un manga en la colección
struct CollectionUpdateRequest: Codable {
    let volumesOwned: [Int]
    let readingVolume: Int?
    let completeCollection: Bool
}

// Request completo para añadir/actualizar manga
struct CollectionRequest: Codable {
    let mangaId: Int
    let data: CollectionUpdateRequest
}

// MARK: - Collection Response Models
// Manga guardado en la colección del usuario desde la nube
struct CloudMangaCollection: Codable {
    let id: String
    let manga: MangaDTO
    let volumesOwned: [Int]
    let readingVolume: Int?
    let completeCollection: Bool
}
