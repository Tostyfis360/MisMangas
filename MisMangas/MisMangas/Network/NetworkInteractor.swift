//
//  NetworkInteractor.swift
//  MisMangas
//
//  Created by Juan Ferrera Sala on 21/12/25.
//

import Foundation

protocol NetworkInteractor {}

extension NetworkInteractor {
    func getJSON<JSON>(_ request: URLRequest, type: JSON.Type) async throws(NetworkError) -> JSON where JSON: Codable {
        let (data, httpResponse) = try await URLSession.shared.getData(for: request)
        if httpResponse.statusCode == 200 {
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                return try decoder.decode(type, from: data)
            } catch {
                throw NetworkError.json(error)
            }
        } else {
            throw NetworkError.status(httpResponse.statusCode)
        }
    }
}
