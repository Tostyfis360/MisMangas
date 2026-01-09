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
            // Fondo
            Color(.systemBackground)
                .ignoresSafeArea()

            VStack(spacing: 30) {
                // Logo o icono de la app
                Image(systemName: "book.pages.fill")
                    .font(.system(size: 80))
                    .foregroundStyle(.blue)
                    .symbolEffect(.bounce, options: .repeating)

                // Título
                Text("MisMangas")
                    .font(.largeTitle)
                    .bold()

                // Indicador de progreso
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
