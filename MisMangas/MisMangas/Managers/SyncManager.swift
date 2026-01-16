//
//  SyncManager.swift
//  MisMangas
//
//  Created by Juan Ferrera Sala on 16/1/26.
//

import SwiftUI
import SwiftData

@Observable
final class SyncManager {
    private let network = NetworkRepository()

    // MARK: - Sync Down (Nube → Local)
    // Descarga la colección desde la nube y la guarda en local
    func syncDown(modelContext: ModelContext) async {
        guard let token = KeychainHelper.getToken() else {
            print("⚠️ No hay token, skip sync")
            return
        }
        do {
            print("📥 Descargando colección desde la nube...")
            let cloudCollection = try await network.getCollection(token: token)
            print("📦 Recibidos \(cloudCollection.count) mangas de la nube")
            // Guardar cada manga en local
            for cloudManga in cloudCollection {
                await saveMangaToLocal(cloudManga: cloudManga, modelContext: modelContext)
            }
            print("✅ Sincronización completada")
        } catch {
            print("❌ Error en syncDown: \(error)")
        }
    }

    // MARK: - Sync Up
    // Sube un manga local a la nube
    func syncUp(manga: UserMangaCollection) async {
        guard let token = KeychainHelper.getToken() else {
            print("⚠️ No hay token, skip sync up")
            return
        }
        do {
            print("📤 Subiendo manga \(manga.title) a la nube...")
            // Crear array de volúmenes
            let volumesArray = manga.volumesOwned > 0 ? Array(1...manga.volumesOwned): []
            try await network.addToCollection(
                token: token,
                mangaId: manga.mangaId,
                volumesOwned: volumesArray,
                readingVolume: manga.readingVolume,
                completeCollection: manga.completeCollection)
            print("✅ Manga subido a la nube")
        } catch {
            print("❌ Error en syncUp: \(error)")
        }
    }

    // MARK: - Delete from Cloud
    // Elimina un manga de la nube
    func deleteFromCloud(mangaId: Int) async {
        guard let token = KeychainHelper.getToken() else {
            print("⚠️ No hay token, skip delete")
            return
        }
        do {
            print("🗑️ Eliminando manga \(mangaId) de la nube...")
            try await network.deleteFromCollection(token: token, mangaId: mangaId)
            print("✅ Manga eliminado de la nube")
        } catch {
            print("❌ Error eliminando de la nube: \(error)")
        }
    }

    // MARK: - Helper: Save to Local
    private func saveMangaToLocal(cloudManga: CloudMangaCollection, modelContext: ModelContext) async {
        // Guardar el ID en una variable en local
        let mangaId = cloudManga.manga.id

        // Buscar si ya existe en local
        let descriptor = FetchDescriptor<UserMangaCollection>(
            predicate: #Predicate { $0.mangaId == mangaId })

        let existing = try? modelContext.fetch(descriptor).first

        if let existing {
            // Actualizar el existente siendo la nube la fuente de verdad
            print("🔄 Actualizando manga local: \(cloudManga.manga.title)")
            existing.volumesOwned = cloudManga.volumesOwned.count
            existing.readingVolume = cloudManga.readingVolume
            existing.completeCollection = cloudManga.completeCollection
            existing.lastUpdated = Date()
        } else {
            // Crear nuevo
            print("➕ Añadiendo nuevo manga local: \(cloudManga.manga.title)")
            let newEntry = UserMangaCollection(
                mangaId: cloudManga.manga.id,
                title: cloudManga.manga.title,
                mainPicture: cloudManga.manga.mainPicture,
                totalVolumes: cloudManga.manga.volumes,
                volumesOwned: cloudManga.volumesOwned.count,
                readingVolume: cloudManga.readingVolume,
                completeCollection: cloudManga.completeCollection)
            modelContext.insert(newEntry)
        }
        // Guardar los cambios
        try? modelContext.save()
    }
}
