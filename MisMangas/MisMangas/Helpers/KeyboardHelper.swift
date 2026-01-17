//
//  KeyboardHelper.swift
//  MisMangas
//
//  Created by Juan Ferrera Sala on 17/1/26.
//

import SwiftUI

enum KeyboardHelper {
    // Oculta el teclado programáticamente
    static func dismiss() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil)
    }
}

// MARK: - View Extension
extension View {
    // Modificador que oculta el teclado al tocar fuera de los campos de texto
    func dismissKeyboardOnTap() -> some View {
        self.onTapGesture {
            KeyboardHelper.dismiss()
        }
    }
}
