//
//  SearchVM.swift
//  MisMangas
//
//  Created by Juan Ferrera Sala on 8/1/26.
//

import SwiftUI

@Observable @MainActor
final class SearchVM {
    var search = ""
    let network = NetworkRepository()
    var mangaResult: [MangaDTO] = []

    func findMangas() async {
        do {
            mangaResult = try await network.searchMangas(beginsWith: search)
        } catch {
            print(error)
        }
    }
}
