//
//  RegisteredChildren.swift
//  Pocket Money
//
//  Created by Dyan on 5/4/23.
//

import SwiftUI

// MARK: - MODEL
struct NewChild {
    var name: String = ""
    var email: String = ""
    var password: String = ""
    var showSheet: Bool = false
}

// MARK: - VIEWMODEL
struct RegisteredChildrenViewModel {
    var child = NewChild()
    
    mutating func showSheetToggle() {
        self.child.showSheet.toggle()
    }
}

struct RegisteredChildren: View {
    @State var viewModel = RegisteredChildrenViewModel()
    
    var body: some View {
        VStack{
            Form{
                Section("Dyan Filipe Rdrigues da silva") {
                    Text("Valor para gastar: R$ 120.00")
                        .font(.subheadline)
                        .foregroundColor(.gray7)
                        .fontWeight(.medium)
                        .listRowSeparator(.hidden)
                    Text("Valor Guardado: R$ 270.00")
                        .foregroundColor(.gray7)
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    Text("Total: R$ 390.00")
                        .foregroundColor(.gray7)
                        .font(.title2)
                        .fontWeight(.medium)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
            }
            .sheet(isPresented: $viewModel.child.showSheet) {
                NavigationView {
                    VStack{
                        Form {
                            Section("Novo filho") {
                                HStack{
                                    Image(systemName: "person.fill")
                                        .foregroundColor(.purple)
                                    TextField("Nome do filho", text: $viewModel.child.name)
                                        .fontWeight(.medium)
                                }
                                .padding()
                                .overlay {
                                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                                        .stroke(Color(UIColor.systemGray4), lineWidth: 2)
                                }
                                .listRowSeparator(.hidden)
                                .padding([.horizontal, .top])
                                
                                HStack{
                                    Image(systemName: "envelope.fill")
                                        .foregroundColor(.purple)
                                    TextField("Email", text: $viewModel.child.email)
                                        .fontWeight(.medium)
                                }
                                .padding()
                                .overlay {
                                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                                        .stroke(Color(UIColor.systemGray4), lineWidth: 2)
                                }
                                .listRowSeparator(.hidden)
                                .padding([.horizontal])
                                
                                HStack{
                                    Image(systemName: "lock.fill")
                                        .foregroundColor(.purple)
                                    TextField("Senha", text: $viewModel.child.password)
                                        .fontWeight(.medium)
                                }
                                .padding()
                                .overlay {
                                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                                        .stroke(Color(UIColor.systemGray4), lineWidth: 2)
                                }
                                .listRowSeparator(.hidden)
                                .padding([.horizontal])
                                
                                
                                Button {
                                    // MARK: Actions
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
                            
                            
                        }
                        
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
        .navigationTitle("Filhos")
        .navigationBarTitleDisplayMode(.automatic)
        .toolbar{
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    viewModel.showSheetToggle()
                } label: {
                    Image(systemName: "plus")
                        .fontWeight(.bold)
                }
            }
        }
        
    }
}

struct RegisteredChildren_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            RegisteredChildren()
        }
    }
}
