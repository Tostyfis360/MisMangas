//
//  KeychainHelper.swift
//  MisMangas
//
//  Created by Juan Ferrera Sala on 16/1/26.
//

import Security
import Foundation

final class KeychainHelper {

    // MARK: - Keys
    private static let service = "com.mismangas.app"
    private static let tokenKey = "jwt_token"

    // MARK: - Save Token
    static func saveToken(_ token: String) -> Bool {
        // Convertir el token a Data
        guard let data = token.data(using: .utf8) else {
            return false
        }

        // Preparar la query para guardar
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: tokenKey,
            kSecValueData as String: data]

        // Eliminar token anterior si existe
        SecItemDelete(query as CFDictionary)

        // Guardar el nuevo token
        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }

    // MARK: - Get Token
    static func getToken() -> String? {
        // Preparar la query para buscar
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: tokenKey,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne]

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        // Si encontró el token
        guard status == errSecSuccess,
              let data = result as? Data,
              let token = String(data: data, encoding: .utf8) else {
            return nil
        }
        return token
    }
    
    // MARK: - Delete Token
    static func deleteToken() -> Bool {
        // Preparar la query para eliminar
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: tokenKey]

        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess
    }
}
