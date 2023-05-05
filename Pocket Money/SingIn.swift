//
//  SingIn.swift
//  Pocket Money
//
//  Created by Dyan on 5/4/23.
//

import SwiftUI

// MARK: - Model
struct SingInAccount {
    var email: String = ""
    var password: String = ""
}

// MARK: - VIEWMODEL
struct SingInViewModel {
    var singInAccount = SingInAccount()
}

struct SingIn: View {
    @State var viewModel = SingInViewModel()
    
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
            
            NavigationLink(destination: {
                RegisteredChildren()
            }, label: {
                Text("Entrar")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .maximum(300, 300))
                    .padding(4)
            })
            .buttonStyle(.borderedProminent)
            .tint(.purple)
            .padding(.bottom)
            
            
        }
        .navigationTitle("Login")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SingIn_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            SingIn()
        }
    }
}
