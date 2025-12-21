//
//  ThemeDTO.swift
//  MisMangas
//
//  Created by Juan Ferrera Sala on 21/12/25.
//

import Foundation

struct ThemeDTO: Codable, Identifiable, Hashable {
    let id: String
    let theme: String
}
