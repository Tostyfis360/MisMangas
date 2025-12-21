//
//  MangaCoverView.swift
//  MisMangas
//
//  Created by Juan Ferrera Sala on 21/12/25.
//

import SwiftUI

struct MangaCoverView: View {
    let coverURL: String?
    let namespace: Namespace.ID
    var big: Bool = false
    
    @State private var image: UIImage?
    @State private var isLoading = false
    
    var body: some View {
        Group {
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: big ? 180 : 90, height: big ? 300 : 150)
                    .clipShape(RoundedRectangle(cornerRadius: 11))
                    .matchedTransitionSource(id: coverURL ?? UUID().uuidString, in: namespace)
            } else if isLoading {
                ProgressView()
                    .frame(width: big ? 180 : 90, height: big ? 300 : 150)
                    .background(.gray.opacity(0.3), in: .rect(cornerRadius: 11))
            } else {
                placeholder
                    .matchedTransitionSource(id: coverURL ?? UUID().uuidString, in: namespace)
            }
        }
        .task {
            await loadImage()
        }
    }
    
    private var placeholder: some View {
        Image(systemName: "book.closed")
            .font(.largeTitle)
            .foregroundStyle(.secondary)
            .frame(width: big ? 180 : 90, height: big ? 300 : 150)
            .background(.gray.opacity(0.3), in: .rect(cornerRadius: 11))
    }
    
    private func loadImage() async {
        // Limpiar comillas si vienen en la URL
        guard let coverURL else { return }
        let cleanURL = coverURL.replacingOccurrences(of: "\"", with: "")
        guard let url = URL(string: cleanURL) else { return }
        
        isLoading = true
        
        // Verificar si está en caché de disco
        let fileURL = ImageDownloader.shared.getFileURL(url: url)
        if FileManager.default.fileExists(atPath: fileURL.path()) {
            do {
                let data = try Data(contentsOf: fileURL)
                self.image = UIImage(data: data)
                isLoading = false
                return
            } catch {
                print("Error loading cached image: \(error)")
            }
        }
        
        // Descargar de la red
        do {
            let downloadedImage = try await ImageDownloader.shared.image(for: url)
            self.image = downloadedImage
        } catch {
            print("Error downloading image: \(error)")
        }
        
        isLoading = false
    }
}

#Preview {
    @Previewable @Namespace var namespace
    MangaCoverView(
        coverURL: "https://cdn.myanimelist.net/images/manga/3/54525.jpg",
        namespace: namespace
    )
}
