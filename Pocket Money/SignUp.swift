//
//  SignUp.swift
//  Pocket Money
//
//  Created by Dyan on 5/4/23.
//

import SwiftUI

enum Profile: String, CaseIterable, Identifiable {
    case father = "pai", mother = "mãe", son = "Filho"
    var id: Self { self }
}

struct SignUp: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var profile: Profile = .son
    
    var body: some View {
        Form {
            HStack{
                Image(systemName: "envelope.fill")
                    .foregroundColor(.purple)
                TextField("E-mail", text: $email)
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
                TextField("Senha", text: $password)
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
                TextField("Confirmar senha", text: $confirmPassword)
                    .fontWeight(.medium)
            }
            .listRowSeparator(.hidden)
            .padding()
            .overlay {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .stroke(Color(UIColor.systemGray4), lineWidth: 2)
            }
          
            
            HStack{
                Picker("Eu sou", selection: $profile) {
                    ForEach(Profile.allCases){ profile in
                        Text(profile.rawValue.capitalized)
                            
                    }
                }
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
                    .frame(maxWidth: .maximum(300, 300))
                    .padding(4)
            }
            .buttonStyle(.borderedProminent)
            .tint(.purple)
            .padding(.bottom)
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
