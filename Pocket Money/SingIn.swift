//
//  SingIn.swift
//  Pocket Money
//
//  Created by Dyan on 5/4/23.
//

import SwiftUI

struct SingIn: View {
    @State private var email: String = ""
    @State private var password: String = ""
    
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
                TextField("E-mail", text: $email)
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
                SecureField("Senha", text: $password)
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
