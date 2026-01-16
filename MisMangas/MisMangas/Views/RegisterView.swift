//
//  RegisterView.swift
//  MisMangas
//
//  Created by Juan Ferrera Sala on 16/1/26.
//

import SwiftUI

struct RegisterView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var showError = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 30) {
                    // Logo o icono
                    Image(systemName: "person.crop.circle.badge.plus")
                        .font(.system(size: 80))
                        .foregroundStyle(.blue)
                        .padding(.top, 40)

                    Text("Crear cuenta")
                        .font(.largeTitle)
                        .bold()

                    // Campos de registro
                    VStack(spacing: 16) {
                        TextField("Email", text: $email)
                            .textContentType(.emailAddress)
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .padding()
                            .background(.thinMaterial, in: .rect(cornerRadius: 12))

                        SecureField("Contraseña (mín. 8 caracteres)", text: $password)
                            .textContentType(.newPassword)
                            .padding()
                            .background(.thinMaterial, in: .rect(cornerRadius: 12))

                        SecureField("Confirmar contraseña", text: $confirmPassword)
                            .textContentType(.newPassword)
                            .padding()
                            .background(.thinMaterial, in: .rect(cornerRadius: 12))
                    }
                    .padding(.horizontal)

                    // Validación visual
                    VStack(alignment: .leading, spacing: 8) {
                        if !password.isEmpty {
                            HStack(spacing: 8) {
                                Image(systemName: password.count >= 8 ? "checkmark.circle.fill" : "xmark.circle.fill")
                                    .foregroundStyle(password.count >= 8 ? .green : .red)
                                Text("Mínimo 8 caracteres")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }

                        if !confirmPassword.isEmpty {
                            HStack(spacing: 8) {
                                Image(systemName: password == confirmPassword ? "checkmark.circle.fill" : "xmark.circle.fill")
                                    .foregroundStyle(password == confirmPassword ? .green : .red)
                                Text("Las contraseñas coinciden")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)

                    // Botón de registro
                    Button {
                        Task {
                            await register()
                        }
                    } label: {
                        Text("Crear cuenta")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .glassEffect(.regular.interactive())
                    }
                    .padding(.horizontal)
                    .disabled(!isFormValid)

                    // Botón de cancelar
                    Button {
                        dismiss()
                    } label: {
                        Text("Ya tengo cuenta")
                            .font(.subheadline)
                            .foregroundStyle(.blue)
                    }

                    Spacer()
                }
            }
            .onTapGesture {
                hideKeyboard()
            }
            .alert("Error", isPresented: $showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
        }
    }

    // MARK: - Form Validation
    private var isFormValid: Bool {
        !email.isEmpty &&
        password.count >= 8 &&
        password == confirmPassword &&
        email.contains("@")
    }

    // MARK: - Register
    private func register() async {
        guard isFormValid else {
            errorMessage = "Por favor, completa todos los campos correctamente"
            showError = true
            return
        }

        do {
            try await AuthManager.shared.register(email: email, password: password)
            dismiss()
        } catch {
            errorMessage = "No se pudo crear la cuenta. Intenta con otro email."
            showError = true
        }
    }
}

// MARK: - Helper
private func hideKeyboard() {
    UIApplication.shared.sendAction(
        #selector(UIResponder.resignFirstResponder),
        to: nil,
        from: nil,
        for: nil
    )
}

#Preview {
    RegisterView()
}
