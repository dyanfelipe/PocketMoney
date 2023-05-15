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
    var name:String = ""
    var email: String = ""
    var password: String = ""
    var confirmPassword: String = ""
    
    enum CodingKeys: String, CodingKey {
        case name
        case email
        case password
        case confirmPassword = "passwordConfirmation"
   }
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
            print(String(data: encoded, encoding: .utf8))
            let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
            print(String(data: data, encoding: .utf8))
            let authenticatedUser = try JSONDecoder().decode(CreateAccountAuth.self, from: data)
            confirmationMessage = AlertSingUp(message: "Usuário criado com sucesso", description: "Você já pode entrar com o novo usuário!")
            self.showingConfirmation = true
        } catch {
            print(String(describing: error.localizedDescription))
            confirmationMessage = AlertSingUp(message: "Recurso existente", description: "Já existe um usuário cadastrado com esse e-mail")
            self.showingConfirmation = true
        }
    }
}

struct SignUp: View {
    @StateObject var viewModel = SignUpViewModel()
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var backButton : some View { Button(action: {
        self.presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
            Image(systemName: "chevron.backward") // BackButton Image
                    .fontWeight(.bold)
                Text("Voltar") //translated Back button title
            }
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical) {
                VStack{
                    HStack{
                        Image(systemName: "person.fill")
                            .foregroundColor(.purple)
                        TextField("Nome", text: $viewModel.createdAccount.name)
                            .autocorrectionDisabled()
                            .autocapitalization(.words)
                            .fontWeight(.medium)
                    }
                    .textFieldBorderIcon()
                    
                    HStack{
                        Image(systemName: "envelope.fill")
                            .foregroundColor(.purple)
                        TextField("E-mail", text: $viewModel.createdAccount.email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
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
            .navigationBarItems(leading: backButton)
            .navigationTitle("Criar conta")
            .navigationBarBackButtonHidden(true)
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
