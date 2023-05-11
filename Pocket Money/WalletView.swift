//
//  ChildHome.swift
//  Pocket Money
//
//  Created by Rodrigo Oliveira on 06/05/23.
//

import SwiftUI

//MARK - MODEL
struct WalletModel: Decodable {
    let id: String
    let name: String
    let amountToSpend: Double
    let savedValue: Double
    let history: [HistoryItemModel]
    
    enum CodingKeys: String, CodingKey {
        case id, name, amountToSpend, savedValue, history = "movimentations"
    }
    
    init(){
        self.id = String()
        self.name = String()
        self.amountToSpend = Double()
        self.savedValue = Double()
        self.history = Array()
    }
    
    init(id: String, name: String, amountToSpend: Double, savedValue: Double, history: [HistoryItemModel]){
        self.id = id
        self.name = name
        self.amountToSpend = amountToSpend
        self.savedValue = savedValue
        self.history = history
    }
}


//MARK - VIEW MODEL
class WalletViewModel: ObservableObject {
    @Published var parent: Bool = UserDefaults.standard.bool(forKey: "parent")
    @Published var walletData = WalletModel()
    
    //    WalletModel(
    //        id: "0000",
    //        name: "Maria Silva Santos",
    //        amountToSpend: 250.0,
    //        savedValue: 510.0,
    //        history: [
    //            HistoryItemModel(amount: -35.0, description: "Lanche", date: "05/05/2023", tag: "Gasto"),
    //            HistoryItemModel(amount: -12.0, description: "Sorvete", date: "01/05/2023", tag: "Gasto"),
    //            HistoryItemModel(amount: 80.0, description: "", date: "20/04/2023", tag: "Guardado"),
    //            HistoryItemModel(amount: 150.0, description: "Mesada", date: "20/04/2023", tag: "Depósito"),
    //            HistoryItemModel(amount: -18.0, description: "Uber", date: "13/04/2023", tag: "Gasto"),
    //        ]
    //    )
    
    func getWallet(chielId: String?) async {
        await walletData = WalletService().getWallet(chielId: chielId)
    }
}


//MARK - SERVICE
class WalletService {
    
    let token = UserDefaults.standard.string(forKey: "token") ?? ""
    
    func getWallet(chielId: String?) async -> WalletModel {
        var wallet = WalletModel()
        var fullUrl = String()
        
        if let id = chielId {
            fullUrl = "https://jab-api-xh0g.onrender.com/api/v1/parents/children/\(id)"
        } else {
            fullUrl = "https://jab-api-xh0g.onrender.com/api/v1/kids"
        }
        
        guard let url = URL(string: fullUrl) else { return wallet }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let decodedResponse = try JSONDecoder().decode(WalletModel.self, from: data)
            wallet = decodedResponse
        } catch {
            print(error.localizedDescription)
        }
        return wallet
    }
}


//MARK - VIEW
struct WalletView: View {
    @StateObject var wallet = WalletViewModel()
    var childId: String?
    
    var body: some View {
        VStack{
            WalletData()
            ActionsButtons(childId: childId)
            WalletHistory()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
        .ignoresSafeArea(edges: .bottom)
        .environmentObject(wallet)
        .onAppear {
            Task{
                await wallet.getWallet(chielId: childId)
            }
        }
    }
    
}
// TODO: Botao nativo navigationBar esta azul validar se vai criar um novo buttom ou vai usar ele.
struct Wallet_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            WalletView()
        }
    }
}


struct WalletData: View {
    @EnvironmentObject var wallet: WalletViewModel
    
    var body: some View {
        VStack {
            Text("Carteira")
                .font(Font.system(Font.TextStyle.largeTitle, weight: Font.Weight.bold))
                .frame(maxWidth: .infinity, alignment: .center)
                .foregroundColor(.black)
                .padding(.bottom, wallet.parent ? 0 : 20)
            
            if(wallet.parent){
                Text(wallet.walletData.name)
                    .font(.system(.body, weight: .semibold))
                    .shadow(color: .white, radius: 10)
                    .padding(.bottom, wallet.parent ? 10 : 0)
            }
            
            Text("Valor para gastar")
                .font(Font.system(Font.TextStyle.callout))
                .foregroundColor(.white)
            
            Text("R$ \(Utils().formatNumberToReal(value: wallet.walletData.amountToSpend))")
                .font(Font.system(Font.TextStyle.largeTitle, weight: Font.Weight.bold))
                .foregroundColor(Color.white)
                .shadow(color: Color.black, radius: 5)
                .padding(.bottom, 5)
            
            Text("Valor guardado")
                .font(Font.system(Font.TextStyle.callout))
                .foregroundColor(.white)
            
            Text("R$ \(Utils().formatNumberToReal(value:  wallet.walletData.savedValue))")
                .font(Font.system(Font.TextStyle.title, weight: Font.Weight.semibold))
                .foregroundColor(Color.white)
                .shadow(color: Color.black, radius: 5)
        }
        .background(
            Circle()
                .fill(.purple.gradient)
                .frame(width: 500, height: 500)
                .shadow(radius: 10)
                .padding(.top, -150)
        )
        //.padding(.top, -50)
    }
}

struct ActionsButtons: View {
    @EnvironmentObject var wallet: WalletViewModel
    var childId: String?
    
    var body: some View {
        HStack {
            
            if(wallet.parent){
                ActionButton(emoji: "💵", sfSimbolName: nil, text: "DEPOSITAR")
                    .padding(.top, -50)
            } else {
                ActionButton(emoji: "💸", sfSimbolName: nil, text: "REGISTRAR GASTO")
                    .padding(.top, -50)
            }
            
            Spacer()
            
            NavigationLink {
                HistoryView(childId: childId)
            } label: {
                ActionButton(emoji: nil, sfSimbolName: "list.bullet", text: "HISTÓRICO")
                    .padding(.top, 30)
            }
            
            Spacer()
            
            if(wallet.parent){
                ActionButton(emoji: "💸", sfSimbolName: nil, text: "SACAR")
                    .padding(.top, -50)
            } else {
                ActionButton(emoji: "💰", sfSimbolName: nil, text: "GUARDAR DINHEIRO")
                    .padding(.top, -50)
            }
        }
        .frame(maxWidth: .infinity, minHeight: 130, alignment: .top)
    }
}

struct ActionButton: View {
    let emoji: String?
    let sfSimbolName: String?
    let text: String
    
    var body: some View {
        VStack(spacing: 5) {
            if(sfSimbolName == nil){
                Text(emoji!)
                    .font(.system(size: 30))
                    .shadow(radius: 5)
            }else if(emoji == nil){
                Image(systemName: sfSimbolName!)
                    .font(.system(size: 30))
                    .shadow(radius: 5)
                    .padding(.bottom, 5)
            }
            
            Text(text)
                .font(Font.system(Font.TextStyle.caption2, weight: .bold))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: 90, maxHeight:90, alignment: .center)
        .foregroundColor(Color.white)
        .background(Color.darkPurple)
        .cornerRadius(100)
        .shadow(color:.black, radius: 10)
    }
}

struct WalletHistory: View {
    @EnvironmentObject var wallet: WalletViewModel
    
    var body: some View {
        GeometryReader { proxy in
            VStack {
                Text("Histórico")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(Font.system(Font.TextStyle.title, weight: Font.Weight.bold))
                
                Text("5 últimas movimentações")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(Font.system(Font.TextStyle.caption))
                    .foregroundColor(.gray7)
                    .padding(.bottom, 5)
                
                
                ScrollView {
                    if(wallet.walletData.history.count == 0){
                        Text("Não há histórico para essa carteira")
                            .foregroundColor(.gray)
                            .padding(.top, proxy.size.height * 0.3)
                    } else {
                        ForEach(wallet.walletData.history, id: \.id) { historyItem in
                            WalletHistoryItem(amount: historyItem.amount, description: historyItem.description, date: historyItem.date, tag: historyItem.tag)
                        }
                    }
                }
                .scrollIndicators(.hidden)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

struct WalletHistoryItem: View {
    let amount: Double
    let description: String
    let date: String
    let tag: String
    
    var body: some View {
        HStack {
            VStack {
                Text(
                    ((tag == "Gasto" || tag == "Saque") ? "-" : "+") +
                    " R$ \(Utils().formatNumberToReal(value: amount))"
                )
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.system(.headline))
                .foregroundColor((tag == "Gasto" || tag == "Saque") ? .red : .green)
                
                if(description != ""){
                    Text(description)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(Font.system(Font.TextStyle.caption))
                        .foregroundColor(.gray7)
                        .padding(.leading, (tag == "Gasto" || tag == "Saque") ? 12 : 15)
                }
                
                Text(Utils().formatDate(dateString: date))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(Font.system(Font.TextStyle.caption))
                    .foregroundColor(.gray)
                    .padding(.leading, (tag == "Gasto" || tag == "Saque") ? 12 : 15)
                
                if(description == ""){
                    Text("")
                }
            }
            .padding()
            
            Text(tag)
                .font(.system(.subheadline, weight: .semibold))
                .padding(2)
                .frame(maxWidth: 100)
                .background(.purple)
                .foregroundColor(.white)
                .cornerRadius(5)
                .padding()
            
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.gray.opacity(0.1))
        .cornerRadius(5)
    }
}
