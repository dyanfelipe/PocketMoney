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
    var confirmationMessage: String = "Error na aplicação"
    var confirmationMessageTitle: String = "Estamos com instabilidade tente mais tarde"
    @Published var selection: String? = nil
    @Published var showingConfirmation: Bool = false
    @Published var userIsAuthenticated: Bool = false
    @AppStorage("token") var token = ""
    @AppStorage("parent") var parent: UserType?
    
    func authenticateUser(accessToken: String, parent: Bool) {
        DispatchQueue.main.async {
            self.token = accessToken
            self.parent = parent ? .dad : .child
            
            if(parent) {
                self.parent = .dad
                self.selection = "RegisteredChildren"
            } else if(parent == false) {
                self.parent = .child
                self.selection = "WhalletView"
            }
            
            self.userIsAuthenticated = true
        }
    }
    
    init() {
        if (token.count > 0){
            userIsAuthenticated = true
        }
    }
    
    func signOut()  {
        userIsAuthenticated = false
        parent = nil
        token = ""
    }
    
    func login() async {
        guard let encoded = try? JSONEncoder().encode(singInAccount) else { return }
        guard let url = URL(string: "https://jab-api-xh0g.onrender.com/api/v1/auth/login") else { return }
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        URLSession.shared.uploadTask(with: request, from: encoded) { data, response, error in
            if let error = error { return }
            
            guard let response = response as? HTTPURLResponse else { return }
            
            if (400...499).contains(response.statusCode) {
                guard let data = data else { return }
                DispatchQueue.main.async {
                    do {
                        let errorAPI = try JSONDecoder().decode(APIError.self, from: data)
                        self.confirmationMessage = errorAPI.description
                            .replacingOccurrences(of: "email must be an email; ", with: "")
                            .replacingOccurrences(of: ";", with: "\n")
                        self.confirmationMessageTitle = errorAPI.message
                        self.showingConfirmation = true
                    } catch {
                        self.showingConfirmation = true
                    }
                }
            }
            
            if response.statusCode == 200 {
                guard let data = data else { return }
                DispatchQueue.main.async {
                    do {
                        let authenticatedUser = try JSONDecoder().decode(Auth.self, from: data)
                        self.authenticateUser(accessToken: authenticatedUser.accessToken, parent: authenticatedUser.parent)
                    } catch {
                        self.showingConfirmation = true
                    }
                }
            }
            
        }.resume()
    }
}
//https://www.hackingwithswift.com/books/ios-swiftui/sending-and-receiving-orders-over-the-internet
//let (data, error) = try await URLSession.shared.upload(for: request, from: encoded)
//let res = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
