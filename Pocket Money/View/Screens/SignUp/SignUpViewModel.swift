//
//  SignUpViewModel.swift
//  Pocket Money
//
//  Created by Dyan on 5/15/23.
//

import Foundation
import SwiftUI

class SignUpViewModel: ObservableObject {
    var createdAccount = CreatedAccount()
    @Published var confirmationMessage = AlertSingUp(message: "", description: "")
    @Published var showingConfirmation: Bool = false
    @State var viewModel = SignInViewModel()
    
    func createUser() async {
        guard let encoded = try? JSONEncoder().encode(createdAccount) else { return }
        guard let url = URL(string: "https://jab-api-xh0g.onrender.com/api/v1/parents") else {return}
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        do {
            let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
            let authenticatedUser = try JSONDecoder().decode(CreateAccountAuth.self, from: data)
            confirmationMessage = AlertSingUp(message: "Usuário criado com sucesso", description: "Você já pode entrar com o novo usuário!")
            self.showingConfirmation = true
        } catch {
            confirmationMessage = AlertSingUp(message: "Recurso existente", description: "Já existe um usuário cadastrado com esse e-mail")
            self.showingConfirmation = true
        }
    }
}
