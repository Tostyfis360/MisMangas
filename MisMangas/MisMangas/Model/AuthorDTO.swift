//
//  AuthorDTO.swift
//  MisMangas
//
//  Created by Juan Ferrera Sala on 21/12/25.
//

import Foundation

struct AuthorDTO: Codable, Identifiable, Hashable {
    let id: String
    let firstName: String
    let lastName: String
    let role: String

    var fullName: String {
        "\(firstName) \(lastName)"
    }
}
