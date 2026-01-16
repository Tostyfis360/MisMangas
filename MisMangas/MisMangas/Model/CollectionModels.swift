//
//  CollectionModels.swift
//  MisMangas
//
//  Created by Juan Ferrera Sala on 16/1/26.
//

// CollectionModels.swift
import Foundation

// MARK: - Collection Request Models
// Request para añadir/actualizar manga en colección
struct CollectionRequest: Codable {
    let manga: Int
    let completeCollection: Bool
    let volumesOwned: [Int]
    let readingVolume: Int?
}

// MARK: - Collection Response Models
// Manga guardado en la colección del usuario (desde la nube)
struct CloudMangaCollection: Codable {
    let id: String
    let manga: MangaDTO
    let volumesOwned: [Int]
    let readingVolume: Int?
    let completeCollection: Bool
}
