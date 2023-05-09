//
//  SignUp.swift
//  Pocket Money
//
//  Created by Dyan on 5/4/23.
//

import SwiftUI

// MARK: - ??
enum Profile: String, CaseIterable, Identifiable {
    case father = "pai", mother = "mãe", son = "Filho"
    var id: Self { self }
}

// MARK: - Model
struct CreatedAccount: Codable {
    var name:String = "olivier"
    var email: String = "olivier@mail.com"
    var password: String = "bestPassw0rd"
    var confirmPassword: String = "bestPassw0rd"
}

struct APIError: Error {
    var statusCode: Int
    var message: String
    var description: String
    var timestamp: String
}

struct AlertSingUp: Codable {
    var message: String
    var description: String
}

struct CreateAccountAuthUser: Decodable {
    let email: String
    let confirmPassword: String
    let id: Int
}


struct CreateAccountAuth: Decodable {
    var id: String
    var name: String
    var email: String
    
    
     enum CodingKeys: String, CodingKey {
         case id
         case name
         case email
    }
}

// MARK: - VIEWMODEL
class SignUpViewModel: ObservableObject {
    var createdAccount = CreatedAccount()
    @Published var confirmationMessage = AlertSingUp(message: "", description: "")
    @Published var showingConfirmation: Bool = false
    @State var viewModel = SingInViewModel()
    
    func createUser() async {
        guard let encoded = try? JSONEncoder().encode(createdAccount) else {
            print("Failed to encode order")
            return
        }
        guard let url = URL(string: "https://jab-api-xh0g.onrender.com/api/v1/parents") else {return}
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        do {
            let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
            let authenticatedUser = try JSONDecoder().decode(CreateAccountAuth.self, from: data)
            confirmationMessage = AlertSingUp(message: "Usuário criado com sucesso", description: "Você já pode entrar com o novo usuário!")
        } catch {
            confirmationMessage = AlertSingUp(message: "Recurso existente", description: "Já existe um usuário cadastrado com esse e-mail")
            self.showingConfirmation = true
        }
    }
}

struct SignUp: View {
    @StateObject var viewModel = SignUpViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical) {
                VStack{
                    HStack{
                        Image(systemName: "person.fill")
                            .foregroundColor(.purple)
                        TextField("Nome", text: $viewModel.createdAccount.name)
                            .fontWeight(.medium)
                    }
                    .textFieldBorderIcon()
                    
                    HStack{
                        Image(systemName: "envelope.fill")
                            .foregroundColor(.purple)
                        TextField("E-mail", text: $viewModel.createdAccount.email)
                            .fontWeight(.medium)
                    }
                    .textFieldBorderIcon()
                    
                    HStack{
                        Image(systemName: "lock.fill")
                            .foregroundColor(.purple)
                        SecureField("Senha", text: $viewModel.createdAccount.password)
                            .fontWeight(.medium)
                    }
                    .textFieldBorderIcon()
                
                    
                    HStack{
                        Image(systemName: "lock.fill")
                            .foregroundColor(.purple)
                        SecureField("Confirmar senha", text: $viewModel.createdAccount.confirmPassword)
                            .fontWeight(.medium)
                    }
                    .textFieldBorderIcon()
                  
                    Button {
                        Task {
                            await viewModel.createUser()
                        }
                    } label: {
                        Text("Cadastrar")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(4)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.purple)
                    .padding()
                }
                .frame(width: geometry.size.width)
                .frame(minHeight: geometry.size.height)
            }
            .navigationTitle("Criar conta")
            .navigationBarTitleDisplayMode(.inline)
            .alert(viewModel.confirmationMessage.message, isPresented: $viewModel.showingConfirmation){
                NavigationLink("Ok", destination: {
                    SingIn()
                })
            } message: {
                Text(viewModel.confirmationMessage.description)
            }
        }

    }
}

struct SignUp_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            SignUp()
        }
    }
}
