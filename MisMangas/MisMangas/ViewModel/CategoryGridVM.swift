//
//  CategoryGridVM.swift
//  MisMangas
//
//  Created by Juan Ferrera Sala on 9/1/26.
//

import SwiftUI

@Observable
final class CategoryGridVM {
    let network = NetworkRepository()
    
    var mangas: [MangaDTO] = []
    
    private var currentPage = 1
    private let itemsPerPage = 20
    var canLoadMore = true
    
    private var currentCategory = ""
    private var currentFilterType: CategoryFilterType = .genre
    
    // MARK: - Load Initial Data
    func loadInitialData(category: String, filterType: CategoryFilterType) async {
        currentCategory = category
        currentFilterType = filterType
        currentPage = 1
        mangas = []
        
        do {
            let response: PaginatedResponse<MangaDTO>
            
            switch filterType {
            case .genre:
                response = try await network.fetchMangas(byGenre: category, page: currentPage, per: itemsPerPage)
            case .demographic:
                response = try await network.fetchMangas(byDemographic: category, page: currentPage, per: itemsPerPage)
            }
            
            self.mangas = response.items
            self.canLoadMore = response.items.count == itemsPerPage
            
        } catch {
            print(error)
        }
    }
    
    // MARK: - Load Next Page
    func loadNextPage() async {
        guard canLoadMore else { return }
        
        currentPage += 1
        
        do {
            let response: PaginatedResponse<MangaDTO>
            
            switch currentFilterType {
            case .genre:
                response = try await network.fetchMangas(byGenre: currentCategory, page: currentPage, per: itemsPerPage)
            case .demographic:
                response = try await network.fetchMangas(byDemographic: currentCategory, page: currentPage, per: itemsPerPage)
            }
            
            mangas.append(contentsOf: response.items)
            canLoadMore = response.items.count == itemsPerPage
            
        } catch {
            print(error)
            currentPage -= 1
        }
    }
}
