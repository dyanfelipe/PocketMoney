//
//  RegisteredChildren.swift
//  Pocket Money
//
//  Created by Dyan on 5/4/23.
//

import SwiftUI

// MARK: - VIEWMODEL

struct ListOfChildrenView: View {
    @EnvironmentObject var viewModel: ListOfChildrenViewModel
    @EnvironmentObject var singInViewModel: SignInViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var backButton : some View { Button(action: {
        if self.presentationMode.wrappedValue.isPresented{
            self.presentationMode.wrappedValue.dismiss()
        } else {
            singInViewModel.signOut()
        }
        }) {
            HStack {
            Image(systemName: "chevron.backward") // BackButton Image
                    .fontWeight(.bold)
                Text("Sair") //translated Back button title
            }
            .foregroundColor(.gray7)
        }
    }
    var body: some View {
        VStack {
            List {
                ForEach(viewModel.childs, id: \.id) { child in
                    let newValueFormatted = viewModel.convetRealToCentsDecimal(savedValueD: String(child.savedValue), amountToSpendD: String(child.amountToSpend))
                    let amountToSpend = viewModel.convetRealToCentsDecimal(value: String(child.amountToSpend))
                    let savedValue = viewModel.convetRealToCentsDecimal(value: String(child.savedValue))
                    Section(child.name) {
                        NavigationLink{
                            WalletView(childId: child.id)
                        } label:{
                            GroupBox() {
                                Text("Valor para gastar: R$ \(amountToSpend)")
                                    .padding([.bottom], 2)
                                    .font(.subheadline)
                                    .foregroundColor(.gray7)
                                    .fontWeight(.medium)
                                    .listRowSeparator(.hidden)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text("Valor Guardado: R$ \(savedValue)")
                                    .padding([.bottom], 4)
                                    .foregroundColor(.gray7)
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text("Total: R$ \(newValueFormatted)")
                                    .foregroundColor(.gray7)
                                    .font(.title2)
                                    .fontWeight(.medium)
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                                
                            }
                            .backgroundStyle(Color(.white))
                            .listRowInsets(EdgeInsets())
                           
                        }
                   
                    }
                    
                }
                .onDelete { offsets in
                    let reversed = Array(viewModel.childs.reversed()) //get the reversed array -- use Array() so we don't get a ReversedCollection
                    let items = Set(offsets.map { reversed[$0].id }) //get the IDs to delete
                    viewModel.childs.removeAll { items.contains($0.id) } //remove the items with IDs that match the Set
                }
            }
            // MARK: - Por que usando essa props ela da erro tendo que remover o navigation da outra tela.
//            .navigationDestination(for: Childs.self){ item in
//                WalletView()
//            }
            .refreshable {
                await viewModel.getChilds()
            }
            .task {
                await viewModel.getChilds()
            }
            .sheet(isPresented: $viewModel.showSheet) {
                AddNewChild()
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
        .navigationTitle("Filhos")
        .navigationBarTitleDisplayMode(.automatic)
        .toolbar{
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    viewModel.showSheetToggle()
                } label: {
                    Image(systemName: "plus")
                        .foregroundColor(.gray7)
                        .fontWeight(.bold)
                }
            }
        }
    }
        
}

struct AddNewChild: View {
    @EnvironmentObject var viewModel: ListOfChildrenViewModel
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ScrollView(.vertical) {
                    VStack{
                        HStack{
                            Image(systemName: "person.fill")
                                .foregroundColor(.purple)
                            TextField("Nome do filho", text: $viewModel.child.name)
                                .autocorrectionDisabled()
                                .fontWeight(.medium)
                        }
                        .textFieldBorderIcon()
                        
                        HStack{
                            Image(systemName: "envelope.fill")
                                .foregroundColor(.purple)
                            TextField("Email", text: $viewModel.child.email)
                                .autocapitalization(.none)
                                .keyboardType(.emailAddress)
                                .fontWeight(.medium)
                        }
                        .textFieldBorderIcon()
                    
                        
                        HStack{
                            Image(systemName: "lock.fill")
                                .foregroundColor(.purple)
                            SecureField("Senha", text: $viewModel.child.password)
                                .fontWeight(.medium)
                        }
                        .textFieldBorderIcon()
                        
                        HStack{
                            Image(systemName: "lock.fill")
                                .foregroundColor(.purple)
                            SecureField("Confirmar senha", text: $viewModel.child.passwordConfirmation)
                                .fontWeight(.medium)
                        }
                        .textFieldBorderIcon()
                      
                        Button {
                            Task{
                                await viewModel.createChild()
                            }
                        } label: {
                            Text("Cadastrar")
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(4)
                        }
                        .padding(.horizontal, 20)
                        .buttonStyle(.borderedProminent)
                        .tint(.purple)
                        .padding(.vertical)
                    }
                    .frame(width: geometry.size.width)
                    .frame(minHeight: geometry.size.height)
                }
                .navigationTitle("Criar acesso")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar{
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            viewModel.showSheetToggle()
                        } label: {
                            Image(systemName: "chevron.backward")
                                .fontWeight(.bold)
                        }
                    }
                }
            }
        }
    }
}


struct RegisteredChildren_Previews: PreviewProvider {
    static let transactionListVM: ListOfChildrenViewModel = {
        let transactionListVM = ListOfChildrenViewModel()
        transactionListVM.childs = transactionListPreviewData
        return transactionListVM
    }()
    static var previews: some View {
        NavigationStack{
            ListOfChildrenView()
                .environmentObject(transactionListVM)
        }
    }
}
