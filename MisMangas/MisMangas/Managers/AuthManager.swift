//
//  AuthManager.swift
//  MisMangas
//
//  Created by Juan Ferrera Sala on 16/1/26.
//

import SwiftUI

@Observable
final class AuthManager {

    // MARK: - Properties
    var isAuthenticated = false
    var currentUser: UserInfo?

    private let network = NetworkRepository()

    // MARK: - Singleton
    static let shared = AuthManager()

    private init() {
        // Verificar si hay un token guardado al iniciar
        checkAuthentication()
    }

    // MARK: - Check Authentication
    func checkAuthentication() {
        if KeychainHelper.getToken() != nil {
            // Hay token guardado, entonces verificar si es válido
            Task {
                await loadUserInfo()
            }
        }
    }

    // MARK: - Register
    func register(email: String, password: String) async throws {
        do {
            // Validar datos
            guard !email.isEmpty, !password.isEmpty else {
                throw AuthError.invalidCredentials
            }

            guard password.count >= 8 else {
                throw AuthError.invalidCredentials
            }

            // Crear usuario en la API
            let request = CreateUserRequest(email: email, password: password)
            try await network.createUser(request: request)

            // Después de crear, se hace un login automático
            try await login(email: email, password: password)

        } catch {
            print("❌ Error en register: \(error)")
            throw error
        }
    }

    // MARK: - Login
    func login(email: String, password: String) async throws {
        do {
            // Validar los datos
            guard !email.isEmpty, !password.isEmpty else {
                throw AuthError.invalidCredentials
            }

            // Login en la API
            let jwtResponse = try await network.loginJWT(email: email, password: password)

            // Guardar el token en el Keychain
            let success = KeychainHelper.saveToken(jwtResponse.token)
            guard success else {
                throw AuthError.networkError
            }

            // Marcar como autenticado
            isAuthenticated = true

            // Cargar info del usuario
            await loadUserInfo()
            print("✅ Login exitoso")

        } catch {
            print("❌ Error en login: \(error)")
            isAuthenticated = false
            currentUser = nil
            throw error
        }
    }
    
    // MARK: - Load User Info
    func loadUserInfo() async {
        do {
            guard let token = KeychainHelper.getToken() else {
                isAuthenticated = false
                return
            }

            // Obtener la info del user desde la API
            let userInfo = try await network.getUserInfo(token: token)
            currentUser = userInfo
            isAuthenticated = true
            print("✅ Usuario cargado: \(userInfo.email)")

        } catch {
            print("❌ Error cargando usuario: \(error)")
            // Token inválido o expirado
            logout()
        }
    }

    // MARK: - Refresh Token
    func refreshToken() async throws {
        do {
            guard let oldToken = KeychainHelper.getToken() else {
                throw AuthError.invalidToken
            }

            // Renovar el token en la API
            let jwtResponse = try await network.refreshJWT(token: oldToken)
            // Guardar el nuevo token
            let success = KeychainHelper.saveToken(jwtResponse.token)

            guard success else {
                throw AuthError.networkError
            }
            print("✅ Token renovado")
        } catch {
            print("❌ Error renovando token: \(error)")
            // Si falla, hacer logout
            logout()
            throw error
        }
    }

    // MARK: - Logout
    func logout() {
        // Eliminar token del Keychain
        _ = KeychainHelper.deleteToken()
        // Limpiar estado
        isAuthenticated = false
        currentUser = nil
        print("✅ Logout exitoso")
    }
}
