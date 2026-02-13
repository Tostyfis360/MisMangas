//
//  AddToCollectionSheet.swift
//  MisMangas
//
//  Created by Juan Ferrera Sala on 4/1/26.
//

import SwiftUI
import SwiftData

struct AddToCollectionSheet: View {
    let manga: MangaDTO
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query private var userCollection: [UserMangaCollection]
    // Estados del formulario
    @State private var volumesOwned: Int
    @State private var readingVolume: String = ""
    @State private var completeCollection: Bool = false
    @FocusState private var isReadingFieldFocused: Bool
    // Control de errores
    @State private var showError = false
    @State private var errorMessage = ""
    // Manager para sincronizar
    @State private var syncManager = SyncManager()
    // Verificar si ya existe en la colección
    private var existingEntry: UserMangaCollection? {
        userCollection.first { $0.mangaId == manga.id }
    }
    private var isEditing: Bool {
        existingEntry != nil
    }
    // Inicializador
    init(manga: MangaDTO) {
        self.manga = manga
        // Inicializar con 0 por defecto
        _volumesOwned = State(initialValue: 0)
    }
    var body: some View {
        NavigationStack {
            Form {
                // MARK: - Información del Manga
                Section {
                    HStack(spacing: 12) {
                        AsyncImage(url: URL(string: manga.mainPicture.replacingOccurrences(of: "\"", with: ""))) { image in
                            image
                                .resizable()
                                .scaledToFill()
                        } placeholder: {
                            Rectangle()
                                .fill(.gray.opacity(0.3))
                        }
                        .frame(width: 60, height: 90)
                        .clipShape(RoundedRectangle(cornerRadius: 8))

                        VStack(alignment: .leading, spacing: 4) {
                            Text(manga.title)
                                .font(.headline)
                                .lineLimit(2)

                            // Info de los volúmenes o el estado
                            if let volumes = manga.volumes {
                                Text("\(volumes) volúmenes")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            } else if manga.status.lowercased() == "currently_publishing" {
                                HStack(spacing: 4) {
                                    Image(systemName: "antenna.radiowaves.left.and.right")
                                    Text("En emisión")
                                }
                                .font(.caption)
                                .foregroundStyle(.orange)
                            }
                        }
                    }
                } header: {
                    Text("Manga")
                }
                // MARK: - Campos del Formulario
                Section {
                    // Número de tomos comprados
                    Stepper(value: $volumesOwned, in: 0...(manga.volumes ?? 999)) {
                        HStack {
                            Text("Tomos comprados")
                            Spacer()
                            Text("\(volumesOwned)")
                                .foregroundStyle(.secondary)
                                .bold()
                        }
                    }
                    // Tomo por el que va leyendo el usuario
                    HStack {
                        Text("Tomo leyendo")
                        Spacer()
                        TextField("Ej: 5", text: $readingVolume)
                            .focused($isReadingFieldFocused)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 80)
                    }
                    // Colección completa, solo si el manga esta terminado
                    if manga.volumes != nil {
                        Toggle("Colección completa", isOn: $completeCollection)
                            .tint(.green)
                            .onChange(of: completeCollection) { _, newValue in
                                if newValue, let totalVolumes = manga.volumes {
                                    volumesOwned = totalVolumes
                                }
                            }
                    }
                } header: {
                    Text("Datos de tu colección")
                } footer: {
                    // Footer dinámico según si está en emisión
                    if manga.volumes != nil {
                        Text("Número de tomos que posees y por cuál vas leyendo actualmente.")
                    } else {
                        Text("Este manga está en emisión. Indica cuántos tomos tienes hasta ahora.")
                    }
                }
                // MARK: - Información Adicional
                if let volumes = manga.volumes {
                    Section {
                        progressView(current: volumesOwned, total: volumes, label: "Progreso de colección")
                        
                        if let reading = Int(readingVolume), reading > 0 {
                            progressView(current: reading, total: volumes, label: "Progreso de lectura")
                        }
                    }
                }
            }
            .scrollDismissesKeyboard(.interactively)
            .navigationTitle(isEditing ? "Editar colección" : "Añadir a colección")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(isEditing ? "Actualizar" : "Guardar") {
                        saveToCollection()
                    }
                }
            }
            .alert("Error", isPresented: $showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
            .onAppear {
                loadExistingData()
            }
        }
    }
    // MARK: - Progress View
    private func progressView(current: Int, total: Int, label: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(label)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Spacer()
                Text("\(current)/\(total)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            ProgressView(value: Double(current), total: Double(total))
                .tint(current == total ? .green : .blue)
        }
    }
    // MARK: - Load Existing Data
    private func loadExistingData() {
        if let existing = existingEntry {
            volumesOwned = existing.volumesOwned
            if let reading = existing.readingVolume {
                readingVolume = "\(reading)"
            }
            completeCollection = existing.completeCollection
        }
    }
    // MARK: - Save to Collection
    private func saveToCollection() {
        // Validaciones
        guard volumesOwned > 0 else {
            errorMessage = "Debes tener al menos 1 tomo comprado"
            showError = true
            return
        }
        // Validar tomo de lectura
        let readingVolumeInt: Int?
        if readingVolume.isEmpty {
            readingVolumeInt = nil
        } else {
            guard let reading = Int(readingVolume), reading > 0 else {
                errorMessage = "El tomo de lectura debe ser un número válido"
                showError = true
                return
            }
            // Validar que no exceda el total de volúmenes
            if let totalVolumes = manga.volumes, reading > totalVolumes {
                errorMessage = "El tomo de lectura no puede ser mayor que \(totalVolumes)"
                showError = true
                return
            }
            // Validar que no exceda los tomos comprados
            if reading > volumesOwned {
                errorMessage = "No puedes estar leyendo un tomo que no tienes comprado"
                showError = true
                return
            }
            readingVolumeInt = reading
        }
        // Guardar o actualizar
        if let existing = existingEntry {
            // Actualizar existente
            existing.volumesOwned = volumesOwned
            existing.readingVolume = readingVolumeInt
            existing.completeCollection = completeCollection
            existing.lastUpdated = Date()
        } else {
            // Crear nuevo
            let newEntry = UserMangaCollection(
                mangaId: manga.id,
                title: manga.title,
                mainPicture: manga.mainPicture,
                totalVolumes: manga.volumes,
                volumesOwned: volumesOwned,
                readingVolume: readingVolumeInt,
                completeCollection: manga.volumes != nil ? completeCollection : false)
            modelContext.insert(newEntry)
        }
        // Guardar cambios
        do {
            try modelContext.save()

            // Sincroniza con la nube si está autenticado
            if AuthManager.shared.isAuthenticated {
                Task {
                    if let savedManga = existingEntry {
                        await syncManager.syncUp(manga: savedManga)
                    } else {
                        // Buscar el manga recién creado
                        let mangaId = manga.id
                        let descriptor = FetchDescriptor<UserMangaCollection>(
                            predicate: #Predicate { $0.mangaId == mangaId }
                        )
                        if let newManga = try? modelContext.fetch(descriptor).first {
                            await syncManager.syncUp(manga: newManga)
                        }
                    }
                }
            }
            dismiss()
        } catch {
            errorMessage = "Error al guardar: \(error.localizedDescription)"
            showError = true
        }
    }
}

#Preview {
    AddToCollectionSheet(manga: .dragonBall)
        .modelContainer(for: UserMangaCollection.self, inMemory: true)
}

