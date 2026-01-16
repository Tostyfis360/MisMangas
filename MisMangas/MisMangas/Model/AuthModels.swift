//
//  AuthModels.swift
//  MisMangas
//
//  Created by Juan Ferrera Sala on 16/1/26.
//

import Foundation

// MARK: - Request Models
struct CreateUserRequest: Codable {
    let email: String
    let password: String
}

struct LoginRequest: Codable {
    let email: String
    let password: String
}

// MARK: - Response Models
struct JWTResponse: Codable {
    let tokenType: String
    let token: String
    let expiresIn: Int
}

struct UserInfo: Codable {
    let id: String
    let email: String
    let isActive: Bool
    let isAdmin: Bool
    let role: String
}

// MARK: - Error
enum AuthError: Error {
    case invalidCredentials
    case networkError
    case invalidToken
}
