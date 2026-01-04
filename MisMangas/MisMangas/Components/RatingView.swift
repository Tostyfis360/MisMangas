//
//  RatingView.swift
//  MisMangas
//
//  Created by Juan Ferrera Sala on 4/1/26.
//

import SwiftUI

struct ScoreRatingView: View {
    let score: Double

    // El score de la API va de 0 a 10, lo converte a 0-5 para respetar el formato de estrellas
    private var normalizedScore: Double {
        score / 2.0
    }

    private var roundedScore: Double {
        (normalizedScore * 100).rounded() / 100
    }

    private var fullStars: Int {
        Int(roundedScore)
    }

    private var partialStar: Double {
        roundedScore - Double(fullStars)
    }

    var body: some View {
        HStack(alignment: .bottom, spacing: 2) {
            // Estrellas completas
            ForEach(0..<fullStars, id: \.self) { _ in
                Image(systemName: "star.fill")
                    .foregroundStyle(.yellow)
            }

            // Estrella parcial si hay
            if partialStar > 0 {
                ZStack(alignment: .leading) {
                    // Estrella gris de fondo
                    Image(systemName: "star.fill")
                        .foregroundStyle(.gray.opacity(0.3))

                    // Estrella amarilla recortada
                    Image(systemName: "star.fill")
                        .foregroundStyle(.yellow)
                        .mask(alignment: .leading) {
                            GeometryReader { geometry in
                                Rectangle()
                                    .frame(width: geometry.size.width * partialStar)
                            }
                        }
                }
                .fixedSize()
            }

            // Estrellas vacías para completar 5
            let emptyStars = 5 - fullStars - (partialStar > 0 ? 1 : 0)
            ForEach(0..<emptyStars, id: \.self) { _ in
                Image(systemName: "star.fill")
                    .foregroundStyle(.gray.opacity(0.3))
            }

            Text(score.formatted(.number.precision(.fractionLength(2))))
                .font(.caption)
                .foregroundStyle(.secondary)
                .padding(.leading, 10)
        }
        .font(.headline)
    }
}

#Preview {
    VStack(spacing: 20) {
        ScoreRatingView(score: 0.0)
        ScoreRatingView(score: 2.5)
        ScoreRatingView(score: 5.0)
        ScoreRatingView(score: 7.5)
        ScoreRatingView(score: 8.41)
        ScoreRatingView(score: 9.21)
        ScoreRatingView(score: 10.0)
    }
    .padding()
}
