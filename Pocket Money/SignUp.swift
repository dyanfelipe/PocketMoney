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
    var email: String = "olivier@mail.com"
    var password: String = "bestPassw0rd"
    var confirmPassword: String = "bestPassw0rd"
}

struct CreateAccountAuthUser: Decodable {
    let email: String
    let confirmPassword: String
    let id: Int
}


struct CreateAccountAuth: Decodable {
    let accessToken: String
    let user: CreateAccountAuthUser
    
    
     enum CodingKeys: String, CodingKey {
        case accessToken
        case user
    }
}

// MARK: - VIEWMODEL
class SignUpViewModel: ObservableObject {
    var createdAccount = CreatedAccount()
    var confirmationMessage = "Tente novamente mais tarde"
    @Published var showingConfirmation: Bool = false
    @State var viewModel = SingInViewModel()
    
    func createUser() async {
        guard let encoded = try? JSONEncoder().encode(createdAccount) else {
            print("Failed to encode order")
            return
        }
        guard let url = URL(string: "http://localhost:3000/register") else {return}
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        do {
            let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
            let authenticatedUser = try JSONDecoder().decode(CreateAccountAuth.self, from: data)
            print(data)
            viewModel.authenticateUser(accessToken: authenticatedUser.accessToken)
        } catch  {
            print(error.localizedDescription)
            self.showingConfirmation = true
        }
    }
}

struct SignUp: View {
    @StateObject var viewModel = SignUpViewModel()
    
    var body: some View {
        Form {
            HStack{
                Image(systemName: "envelope.fill")
                    .foregroundColor(.purple)
                TextField("E-mail", text: $viewModel.createdAccount.email)
                    .fontWeight(.medium)
            }
           
            .listRowSeparator(.hidden)
            .padding()
            .overlay {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .stroke(Color(UIColor.systemGray4), lineWidth: 2)
            }
            .padding(.top)
            
            HStack{
                Image(systemName: "lock.fill")
                    .foregroundColor(.purple)
                SecureField("Senha", text: $viewModel.createdAccount.password)
                    .fontWeight(.medium)
            }
            .listRowSeparator(.hidden)
            .padding()
            .overlay {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .stroke(Color(UIColor.systemGray4), lineWidth: 2)
            }
        
            
            HStack{
                Image(systemName: "lock.fill")
                    .foregroundColor(.purple)
                SecureField("Confirmar senha", text: $viewModel.createdAccount.confirmPassword)
                    .fontWeight(.medium)
            }
            .listRowSeparator(.hidden)
            .padding()
            .overlay {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .stroke(Color(UIColor.systemGray4), lineWidth: 2)
            }
          
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
            .padding(.vertical)
        }
        .navigationTitle("Criar conta")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Error ao realizar o cadastro", isPresented: $viewModel.showingConfirmation){
            Button("OK"){}
        } message: {
            Text(viewModel.confirmationMessage)
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
