//
//  RegisteredChildren.swift
//  Pocket Money
//
//  Created by Dyan on 5/4/23.
//

import SwiftUI

// MARK: - MODEL
struct NewChild: Codable {
    var id: Int = 0
    var name: String = "Breno Gabriel Ferreira"
    var email: String = "breno_ferreira@grupoannaprado.com.br"
    var password: String = "senhanoSpace"
}

struct Childs: Codable {
    let id: Int
    let email: String
    let name: String
    let savedValue: String
    let amountToSpend: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case email
        case savedValue = "saved_value"
        case amountToSpend = "amount_to_spend"
    }
}

// MARK: - VIEWMODEL
class RegisteredChildrenViewModel: ObservableObject {
    var child = NewChild()
    @Published var showSheet: Bool = false
    @Published var childs: [Childs] = []
    
     func showSheetToggle() {
        self.showSheet.toggle()
    }
    

    
    func getChilds() async {
        guard let url = URL(string: "http://localhost:3000/childs") else {return}
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decodedResponse = try JSONDecoder().decode([Childs].self, from: data)
            childs = decodedResponse
        }catch {
            print(error.localizedDescription)
        }
    }
    
    func createChild() async {
        guard let encoded = try? JSONEncoder().encode(child) else {
            print("Failed to encode order")
            return
        }
        guard let url = URL(string: "http://localhost:3000/childs") else {return}
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        do {
            let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
            let userCreated = try JSONDecoder().decode(NewChild.self, from: data)
            print(userCreated)
        } catch  {
            print(error.localizedDescription)
//            self.showingConfirmation = true
        }
    }
    
    func convetRealToCentsDecimal(savedValueD: String, amountToSpendD: String) -> String {
        let savedValueD = Double(savedValueD) ?? 0.0
        let amountToSpendD = Double(amountToSpendD) ?? 0.0
        let sumDouble = ((savedValueD + amountToSpendD) / 100) * 100
        
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale(identifier: "pt_BR")
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: sumDouble)) ?? "0.0"
        
    }
    
    
}

struct RegisteredChildren: View {
    @StateObject var viewModel = RegisteredChildrenViewModel()
    
    var body: some View {
        VStack{
            Form{
                ForEach(viewModel.childs, id: \.id ) { child in
                    let newValueFormatted = viewModel.convetRealToCentsDecimal(savedValueD: child.savedValue, amountToSpendD: child.amountToSpend)
                    Section(child.name) {
                        Text("Valor para gastar: R$ \(child.amountToSpend)")
                            .font(.subheadline)
                            .foregroundColor(.gray7)
                            .fontWeight(.medium)
                            .listRowSeparator(.hidden)
                        Text("Valor Guardado: R$ \(child.savedValue)")
                            .foregroundColor(.gray7)
                            .font(.subheadline)
                            .fontWeight(.medium)
                        
                        Text("Total: R$ \(newValueFormatted)")
                            .foregroundColor(.gray7)
                            .font(.title2)
                            .fontWeight(.medium)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                }

            }
            .task {
                await viewModel.getChilds()
            }
            .sheet(isPresented: $viewModel.showSheet) {
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
                                    SecureField("Senha", text: $viewModel.child.password)
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
