//
//  SingIn.swift
//  Pocket Money
//
//  Created by Dyan on 5/4/23.
//

import SwiftUI

// MARK: - Model
struct SingInAccount: Codable {
    var email: String = "olivier@mail.com"
    var password: String = "bestPassw0rd"
}

struct User: Decodable {
    let email: String
    let firstName: String
    let lastName: String
    let age: Int
    let id: Int
    
     enum CodingKeys: String, CodingKey {
        case email
        case firstName = "firstname"
        case lastName = "lastname"
        case age
        case id
    }
}

struct Auth: Decodable {
    let accessToken: String
    let user: User
    
    
     enum CodingKeys: String, CodingKey {
        case accessToken
        case user
    }
}

// MARK: - VIEWMODEL
struct SingInViewModel {
    var singInAccount = SingInAccount()
}

struct SingIn: View {
    @State var viewModel = SingInViewModel()
    
    @State private var confirmationMessage: String = "Deseja tentar novamente"
    @State private var showingConfirmation: Bool = false
    
    var body: some View {
        VStack{
            Image("happy.family")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 300, maxHeight: 300)
                .padding([.bottom])
            
            HStack{
                Image(systemName: "envelope.fill")
                    .foregroundColor(.purple)
                TextField("E-mail", text: $viewModel.singInAccount.email)
                    .fontWeight(.medium)
            }
            .padding()
            .overlay {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .stroke(Color(UIColor.systemGray4), lineWidth: 2)
            }
            .padding([.horizontal])
            
            
            HStack{
                Image(systemName: "lock.fill")
                    .foregroundColor(.purple)
                SecureField("Senha", text: $viewModel.singInAccount.password)
            }
            .padding()
            .overlay {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .stroke(Color(UIColor.systemGray4), lineWidth: 2)
            }
            .padding()
            
            Button{
                Task {
                    await placeOrder()
                }
            } label: {
                Text("Entrar")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .maximum(300, 300))
                    .padding(4)
            }
            .buttonStyle(.borderedProminent)
            .tint(.purple)
            .padding(.bottom)
            
            
        }
        .navigationTitle("Login")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Email ou senha incorreto", isPresented: $showingConfirmation){
            Button("OK"){}
        } message: {
            Text(confirmationMessage)
        }
    }
    
    func placeOrder() async {
        guard let encoded = try? JSONEncoder().encode(viewModel.singInAccount) else {
            print("Failed to encode order")
            return
        }
        guard let url = URL(string: "http://localhost:3000/login") else {return}
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        do {
            let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
            let decodedSingIN = try JSONDecoder().decode(Auth.self, from: data)
            print("code \(decodedSingIN)")
        } catch {
            print(error.localizedDescription)
        }
    }
}



struct SingIn_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            SingIn()
        }
    }
}
