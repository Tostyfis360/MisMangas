//
//  LoadingView.swift
//  MisMangas
//
//  Created by Juan Ferrera Sala on 9/1/26.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()

            VStack(spacing: 30) {
                Image(systemName: "book.pages.fill")
                    .font(.system(size: 80))
                    .foregroundStyle(.white)
                    .symbolEffect(.bounce, options: .repeating.speed(1))

                Text("MisMangas")
                    .font(.largeTitle)
                    .bold()

                ProgressView()
                    .scaleEffect(1.5)
                    .padding(.top, 20)

                Text("Cargando catálogo...")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    LoadingView()
}
