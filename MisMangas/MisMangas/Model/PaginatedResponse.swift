//
//  PaginatedResponse.swift
//  MisMangas
//
//  Created by Juan Ferrera Sala on 21/12/25.
//

import Foundation

struct PaginatedResponse<T: Codable>: Codable {
    let data: [T]
    let metadata: Metadata
    
    struct Metadata: Codable {
        let total: Int
        let page: Int
        let per: Int
    }
}
