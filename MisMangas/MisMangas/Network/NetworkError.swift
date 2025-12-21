//
//  NetworkError.swift
//  MisMangas
//
//  Created by Juan Ferrera Sala on 21/12/25.
//

import Foundation

public enum NetworkError: LocalizedError {
    case general(Error)
    case status(Int)
    case json(Error)
    case dataNotValid
    case nonHTTP

    public var errorDescription: String? {
        switch self {
        case .general(let error):
            error.localizedDescription
        case .status(let int):
            "HTTP status code: \(int)"
        case .json(let error):
            "JSON error: \(error)"
        case .dataNotValid:
            "Invalid data received from server"
        case .nonHTTP:
            "URLSession did not return a HTTPURLResponse"
        }
    }
}
