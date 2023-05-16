//
//  SingIn.swift
//  Pocket Money
//
//  Created by Dyan on 5/4/23.
//

import SwiftUI

struct SignInView: View {
    @EnvironmentObject var viewModel: SignInViewModel
    @EnvironmentObject var registeredChildren: ListOfChildrenViewModel
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
            NavigationLink(destination: ListOfChildrenView(), tag: "RegisteredChildren", selection: $selection) { EmptyView() }.buttonStyle(PlainButtonStyle())
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
    static let viewModel: SignInViewModel = {
        let transactionListVM = SignInViewModel()
        return transactionListVM
    }()
    static let registeredChildrenViewModel: ListOfChildrenViewModel = {
        let transactionListVM = ListOfChildrenViewModel()
        transactionListVM.childs = transactionListPreviewData
        return transactionListVM
    }()
    static var previews: some View {
        NavigationStack{
            SignInView()
                .environmentObject(viewModel)
                .environmentObject(registeredChildrenViewModel)
        }
    }
}
