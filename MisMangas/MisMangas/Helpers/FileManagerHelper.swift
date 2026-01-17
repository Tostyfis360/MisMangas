//
//  FileManagerHelper.swift
//  MisMangas
//
//  Created by Juan Ferrera Sala on 17/1/26.
//

import Foundation

enum FileManagerHelper {
    // Asegura que los directorios esenciales de la app existan
    static func ensureAppDirectoriesExist() {
        let fileManager = FileManager.default

        // Application Support para SwiftData
        if let appSupport = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first {
            try? fileManager.createDirectory(at: appSupport, withIntermediateDirectories: true)
        }

        // Caches para las imágenes
        let caches = URL.cachesDirectory
        try? fileManager.createDirectory(at: caches, withIntermediateDirectories: true)
    }
}
