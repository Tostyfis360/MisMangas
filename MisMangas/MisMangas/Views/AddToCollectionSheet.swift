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
    
    // Control de errores
    @State private var showError = false
    @State private var errorMessage = ""
    
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
                            
                            if let volumes = manga.volumes {
                                Text("\(volumes) volúmenes")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
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
                    
                    // Tomo por el que va leyendo
                    HStack {
                        Text("Tomo leyendo")
                        Spacer()
                        TextField("Ej: 5", text: $readingVolume)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 80)
                    }
                    
                    // Colección completa
                    Toggle("Colección completa", isOn: $completeCollection)
                        .onChange(of: completeCollection) { _, newValue in
                            if newValue, let totalVolumes = manga.volumes {
                                volumesOwned = totalVolumes
                            }
                        }
                    
                } header: {
                    Text("Datos de tu colección")
                } footer: {
                    Text("Número de tomos que posees y por cuál vas leyendo actualmente.")
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
                completeCollection: completeCollection)
            modelContext.insert(newEntry)
        }

        // Guardar cambios
        do {
            try modelContext.save()
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

