//
//  LoginView.swift
//  MisMangas
//
//  Created by Juan Ferrera Sala on 16/1/26.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var showRegister = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                // Icono
                Image(systemName: "book.pages.fill")
                    .font(.system(size: 80))
                    .foregroundStyle(.white)
                    .padding(.top, 60)

                Text("MisMangas")
                    .font(.largeTitle)
                    .bold()

                // Campos de login
                VStack(spacing: 16) {
                    TextField("Email", text: $email)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .padding()
                        .background(.thinMaterial, in: .rect(cornerRadius: 12))

                    SecureField("Contraseña", text: $password)
                        .textContentType(.password)
                        .padding()
                        .background(.thinMaterial, in: .rect(cornerRadius: 12))
                }
                .padding(.horizontal)

                // Botón de login
                Button {
                    Task {
                        await login()
                    }
                } label: {
                    Text("Iniciar sesión")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .glassEffect(.regular.interactive())
                }
                .padding(.horizontal)
                .disabled(email.isEmpty || password.isEmpty)

                // Botón de registro
                Button {
                    showRegister = true
                } label: {
                    Text("¿No tienes cuenta? Regístrate")
                        .font(.subheadline)
                        .foregroundStyle(.blue)
                }
                Spacer()
            }
            .onTapGesture {
                hideKeyboard()
            }
            .alert("Error", isPresented: $showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
            .sheet(isPresented: $showRegister) {
                RegisterView()
            }
        }
    }

    // MARK: - Login
    private func login() async {
        do {
            try await AuthManager.shared.login(email: email, password: password)
        } catch {
            errorMessage = "Email o contraseña incorrectos"
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
        for: nil)
}

#Preview {
    LoginView()
}
