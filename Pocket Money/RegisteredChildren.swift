//
//  RegisteredChildren.swift
//  Pocket Money
//
//  Created by Dyan on 5/4/23.
//

import SwiftUI

// MARK: - MODEL
struct NewChild: Codable {
    var name: String = ""
    var email: String = ""
    var password: String = ""
    var passwordConfirmation: String = ""
}

struct RaisedChild: Codable {
    var id: String
    var name: String
    var email: String
}

struct Childs: Codable, Hashable {
    let id: String
    let name: String
    let savedValue: Double
    let amountToSpend: Double
}

// MARK: - VIEWMODEL
class RegisteredChildrenViewModel: ObservableObject {
    var child = NewChild()
    @Published var showSheet: Bool = false
    @Published var childs: [Childs] = []
    @StateObject var singInViewModel = SingInViewModel()
    
     func showSheetToggle() {
        self.showSheet.toggle()
    }
    
    func getChilds() async {
        let fullUrl = "https://jab-api-xh0g.onrender.com/api/v1/parents/children"
        guard let url = URL(string: fullUrl) else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer \(singInViewModel.token)", forHTTPHeaderField: "Authorization")

        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            print(String(describing: data))
            let decodedResponse = try JSONDecoder().decode([Childs].self, from: data)
            childs = decodedResponse
        }catch {
            print(error.localizedDescription)
            error.localizedDescription
        }
    }
    
    func createChild() async {
        guard let encoded = try? JSONEncoder().encode(child) else {
            print("Failed to encode order")
            return
        }
        guard let url = URL(string: "https://jab-api-xh0g.onrender.com/api/v1/kids") else {return}
        var request = URLRequest(url: url)
        let authorizationKey = "Bearer ".appending(singInViewModel.token)
        request.setValue(authorizationKey, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        do {
            let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
            let userCreated = try JSONDecoder().decode(RaisedChild.self, from: data)
            await getChilds()
            showSheetToggle()
        } catch  {
            print(String(describing: error))
            print(error.localizedDescription)
        }
    }
    
    func convetRealToCentsDecimal(savedValueD: String, amountToSpendD: String) -> String {
        let savedValueD = Double(savedValueD) ?? 0.0
        let amountToSpendD = Double(amountToSpendD) ?? 0.0
        let sumDouble = ((savedValueD + amountToSpendD) / 100) * 100
        let newValue = formatNumberToReal(value: sumDouble)
        return newValue
    }
    
    func convetRealToCentsDecimal(value: String) -> String {
        let value = Double(value) ?? 0.0
        let valueNewFormatted = (value / 100) * 100
        let newValue = formatNumberToReal(value: valueNewFormatted)
        return newValue
    }
    
    func formatNumberToReal(value: Double) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale(identifier: "pt_BR")
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: value)) ?? "0.0"
    }
}

struct RegisteredChildren: View {
    @EnvironmentObject var viewModel: RegisteredChildrenViewModel
    @EnvironmentObject var singInViewModel: SingInViewModel
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
    @EnvironmentObject var viewModel: RegisteredChildrenViewModel
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
    static let transactionListVM: RegisteredChildrenViewModel = {
        let transactionListVM = RegisteredChildrenViewModel()
        transactionListVM.childs = transactionListPreviewData
        return transactionListVM
    }()
    static var previews: some View {
        NavigationStack{
            RegisteredChildren()
                .environmentObject(transactionListVM)
        }
    }
}
