//
//  GenreDTO.swift
//  MisMangas
//
//  Created by Juan Ferrera Sala on 21/12/25.
//

import Foundation

struct GenreDTO: Codable, Identifiable, Hashable {
    let id: String
    let genre: String
}
