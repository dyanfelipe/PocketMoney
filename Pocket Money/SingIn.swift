//
//  SingIn.swift
//  Pocket Money
//
//  Created by Dyan on 5/4/23.
//

import SwiftUI

// MARK: - UTILS.

struct TextFieldBorderIcon: ViewModifier { // .modifier(TextFieldBorderIcon())
    func body(content: Content) -> some View {
        content
        .padding()
        .overlay {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .stroke(Color(UIColor.systemGray4), lineWidth: 2)
        }
        .padding([.horizontal])
    }
}

extension View {
    func textFieldBorderIcon() -> some View {
        modifier(TextFieldBorderIcon())
    }
}

// MARK: - Model
struct SingInAccount: Codable {
    var email: String = ""
    var password: String = ""
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
    let parent: Bool
    
    enum CodingKeys: String, CodingKey{
        case accessToken = "token"
        case parent
    }
}

// MARK: - VIEWMODEL
class SingInViewModel: ObservableObject {
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

struct SingIn: View {
    @EnvironmentObject var viewModel: SingInViewModel
    @EnvironmentObject var registeredChildren: RegisteredChildrenViewModel
    @State private var selection: String? = nil
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
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .fontWeight(.medium)
            }
            .textFieldBorderIcon()
            // TODO: Change link NavigationLink
            NavigationLink(destination: RegisteredChildren(), tag: "RegisteredChildren", selection: $selection) { EmptyView() }.buttonStyle(PlainButtonStyle())
            NavigationLink(destination: WalletView(), tag: "WhalletView", selection: $selection) { EmptyView() }.buttonStyle(PlainButtonStyle())
            
            HStack{
                Image(systemName: "lock.fill")
                    .foregroundColor(.purple)
                SecureField("Senha", text: $viewModel.singInAccount.password)
            }
            .textFieldBorderIcon()
            
            Button {
                Task {
                    await viewModel.login()
                    if(viewModel.parent){
                        selection = "RegisteredChildren"
                    }else {
                        selection = "WhalletView"
                    }
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
            .padding(.vertical)
            
        }
        .navigationTitle("Login")
        .navigationViewStyle(.stack)
        .accentColor(.gray7)
        .navigationBarTitleDisplayMode(.inline)
        .alert("Email ou senha incorreto", isPresented: $viewModel.showingConfirmation){
            Button("OK"){}
        } message: {
            Text(viewModel.confirmationMessage)
        }
    }
}

struct SingIn_Previews: PreviewProvider {
    static let viewModel: SingInViewModel = {
        let transactionListVM = SingInViewModel()
        return transactionListVM
    }()
    static let registeredChildrenViewModel: RegisteredChildrenViewModel = {
        let transactionListVM = RegisteredChildrenViewModel()
        transactionListVM.childs = transactionListPreviewData
        return transactionListVM
    }()
    static var previews: some View {
        NavigationStack{
            SingIn()
                .environmentObject(viewModel)
                .environmentObject(registeredChildrenViewModel)
        }
    }
}
