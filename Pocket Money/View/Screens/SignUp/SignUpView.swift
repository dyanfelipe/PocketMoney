//
//  SignUp.swift
//  Pocket Money
//
//  Created by Dyan on 5/4/23.
//

import SwiftUI


struct SignUpView: View {
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
                    SignInView()
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
            SignUpView()
        }
    }
}
