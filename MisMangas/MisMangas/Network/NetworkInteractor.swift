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

    // MARK: - POST with body and response
    func postJSON<T: Codable, R: Codable>(_ request: URLRequest, body: T, type: R.Type) async throws(NetworkError) -> R where R: Codable {
        var request = request

        do {
            request.httpBody = try JSONEncoder().encode(body)
        } catch {
            throw NetworkError.json(error)
        }

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

    // MARK: - POST with body, no response
    func postVoid<T: Codable>(_ request: URLRequest, body: T) async throws(NetworkError) {
        var request = request

        do {
            request.httpBody = try JSONEncoder().encode(body)
        } catch {
            throw NetworkError.json(error)
        }

        let (_, httpResponse) = try await URLSession.shared.getData(for: request)

        if httpResponse.statusCode != 201 {
            throw NetworkError.status(httpResponse.statusCode)
        }
    }
    
    // MARK: - POST no body, with response
    func postJSON<R: Codable>(_ request: URLRequest, type: R.Type) async throws(NetworkError) -> R {
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

    // MARK: - DELETE
    func deleteVoid(_ request: URLRequest) async throws(NetworkError) {
        let (_, httpResponse) = try await URLSession.shared.getData(for: request)
        
        if httpResponse.statusCode != 200 {
            throw NetworkError.status(httpResponse.statusCode)
        }
    }
}
