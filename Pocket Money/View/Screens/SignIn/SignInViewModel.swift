//
//  SignInViewModel.swift
//  Pocket Money
//
//  Created by Dyan on 5/15/23.
//

import Foundation
import SwiftUI

class SignInViewModel: ObservableObject {
    var singInAccount = SingInAccount()
    var confirmationMessage: String = "Tente novamente mais tarde"
    @Published var showingConfirmation: Bool = false
    @Published var userIsAuthenticated: Bool = false
    @AppStorage("token") var token = ""
    @AppStorage("parent") var parent = false
    
    func authenticateUser(accessToken: String, parent: Bool) {
        token = accessToken
        self.parent = parent
        userIsAuthenticated = true
    }
    
    init() {
        if (token.count > 0){
            userIsAuthenticated = true
        }
    }
    
    func signOut()  {
        userIsAuthenticated = false
        token = ""
    }
    
    func login() async {
        guard let encoded = try? JSONEncoder().encode(singInAccount) else {
            print("Failed to encode order")
            return
        }
        guard let url = URL(string: "https://jab-api-xh0g.onrender.com/api/v1/auth/login") else {return}
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        do {
            let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
            let authenticatedUser = try JSONDecoder().decode(Auth.self, from: data)
            authenticateUser(accessToken: authenticatedUser.accessToken, parent: authenticatedUser.parent)
        } catch  {
            self.showingConfirmation = true
        }
    }
}
