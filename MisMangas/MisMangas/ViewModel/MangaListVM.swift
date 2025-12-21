//
//  MangaListVM.swift
//  MisMangas
//
//  Created by Juan Ferrera Sala on 21/12/25.
//

import SwiftUI

@Observable @MainActor
final class MangaListVM {
    let network = NetworkRepository()
    
    var mangas: [MangaDTO] = []
    var genres: [String] = []
    var selectedGenre: String?
    var isLoading = false
    var errorMessage: String?
    
    private var currentPage = 1
    private let itemsPerPage = 20
    var totalMangas = 0
    var canLoadMore = true
    
    // MARK: - Load Initial Data
    func loadInitialData() async {
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil
        currentPage = 1
        mangas = []
        
        do {
            let mangasResult = try await network.fetchMangas(page: currentPage, per: itemsPerPage)
            let genresResult = try await network.fetchGenres()
            
            self.mangas = mangasResult.items
            self.totalMangas = mangasResult.metadata.total
            self.genres = genresResult.sorted()
            self.canLoadMore = mangas.count < totalMangas
            
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    // MARK: - Load Next Page
    func loadNextPage() async {
        guard !isLoading, canLoadMore else { return }
        isLoading = true
        currentPage += 1
        
        do {
            let response: PaginatedResponse<MangaDTO>
            
            if let genre = selectedGenre {
                response = try await network.fetchMangas(byGenre: genre, page: currentPage, per: itemsPerPage)
            } else {
                response = try await network.fetchMangas(page: currentPage, per: itemsPerPage)
            }
            
            mangas.append(contentsOf: response.items)
            canLoadMore = mangas.count < response.metadata.total
            
        } catch {
            errorMessage = error.localizedDescription
            currentPage -= 1
        }
        
        isLoading = false
    }
    
    // MARK: - Filter by Genre
    func filterByGenre(_ genre: String?) async {
        guard !isLoading else { return }
        selectedGenre = genre
        isLoading = true
        errorMessage = nil
        currentPage = 1
        mangas = []
        
        do {
            let response: PaginatedResponse<MangaDTO>
            
            if let genre {
                response = try await network.fetchMangas(byGenre: genre, page: currentPage, per: itemsPerPage)
            } else {
                response = try await network.fetchMangas(page: currentPage, per: itemsPerPage)
            }
            
            self.mangas = response.items
            self.totalMangas = response.metadata.total
            self.canLoadMore = mangas.count < totalMangas
            
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}
