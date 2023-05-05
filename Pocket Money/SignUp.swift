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
struct CreatedAccount {
    var email: String = ""
    var password: String = ""
    var confirmPassword: String = ""
}

// MARK: - VIEWMODEL
struct SignUpViewModel {
    var createdAccount = CreatedAccount()
}

struct SignUp: View {
    @State var viewModel = SignUpViewModel()
    
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
                TextField("Senha", text: $viewModel.createdAccount.password)
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
                TextField("Confirmar senha", text: $viewModel.createdAccount.confirmPassword)
                    .fontWeight(.medium)
            }
            .listRowSeparator(.hidden)
            .padding()
            .overlay {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .stroke(Color(UIColor.systemGray4), lineWidth: 2)
            }
          
            Button {
                // MARK: Actions
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
        
    }
}

struct SignUp_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            SignUp()
        }
    }
}
