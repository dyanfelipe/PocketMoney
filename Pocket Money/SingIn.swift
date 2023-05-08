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
    
    
     enum CodingKeys: String, CodingKey {
        case accessToken
    }
}

// MARK: - VIEWMODEL
class SingInViewModel: ObservableObject {
    var singInAccount = SingInAccount()
    var confirmationMessage: String = "Tente novamente mais tarde"
    @Published var showingConfirmation: Bool = false
    @Published var userIsAuthenticated: Bool = false
    @AppStorage("token") var token = ""
    
    func authenticateUser(accessToken: String) {
        token = accessToken
        userIsAuthenticated = true
    }
    
    init() {
        if (token.count > 0){
            userIsAuthenticated = true
        }
    }
    
    func placeOrder() async {
        guard let encoded = try? JSONEncoder().encode(singInAccount) else {
            print("Failed to encode order")
            return
        }
        guard let url = URL(string: "http://localhost:3000/login") else {return}
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        do {
            let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
            let authenticatedUser = try JSONDecoder().decode(Auth.self, from: data)
            authenticateUser(accessToken: authenticatedUser.accessToken)
        } catch  {
            self.showingConfirmation = true
        }
    }
}

struct SingIn: View {
    @EnvironmentObject var viewModel: SingInViewModel
    
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
            
            Button {
                Task {
                    await viewModel.placeOrder()
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
            
//            NavigationLink(value: navi) {
//                if let hasValue = navi {
//                    RegisteredChildren()
//                }
//
//            }
        }
        .navigationTitle("Login")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Email ou senha incorreto", isPresented: $viewModel.showingConfirmation){
            Button("OK"){}
        } message: {
            Text(viewModel.confirmationMessage)
        }
    }
}

struct SingIn_Previews: PreviewProvider {
    static let transactionListVM: SingInViewModel = {
        let transactionListVM = SingInViewModel()
        return transactionListVM
    }()
    
    static var previews: some View {
        NavigationStack{
            SingIn()
                .environmentObject(transactionListVM)
        }
    }
}
