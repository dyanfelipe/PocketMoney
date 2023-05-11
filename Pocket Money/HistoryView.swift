//
//  WalletStatementView.swift
//  Pocket Money
//
//  Created by Rodrigo Oliveira on 07/05/23.
//

import SwiftUI

//MARK - MODEL
struct HistoryItemModel: Codable, Hashable {
    let amount: Double
    let description: String
    let date: String
    let tag: String
    var id: String
    
    enum CodingKeys: String, CodingKey {
        case amount = "value"
        case description
        case date = "createdAt"
        case tag = "type"
        case id
    }
    
    init(amount: Double, description: String, date: String, tag: String){
        self.amount = amount
        self.description = description
        self.date = date
        self.tag = tag
        self.id = (String(amount) + description + date + tag)
    }
    
}


//MARK - VIEW MODEL
class HistoryViewModel: ObservableObject {
    @Published var history: [HistoryItemModel] = []
    
//    HistoryItemModel(amount: -35.0, description: "Lanche", date: "05/05/2023", tag: "Gasto"),
//    HistoryItemModel(amount: -12.0, description: "Sorvete", date: "01/05/2023", tag: "Gasto"),
//    HistoryItemModel(amount: 80.0, description: "", date: "20/04/2023", tag: "Guardado"),
//    HistoryItemModel(amount: 150.0, description: "Mesada", date: "20/04/2023", tag: "Depósito"),
//    HistoryItemModel(amount: -18.0, description: "Uber", date: "13/04/2023", tag: "Gasto"),
//    HistoryItemModel(amount: -5.0, description: "Chocolate", date: "13/04/2023", tag: "Gasto"),
//    HistoryItemModel(amount: -31.0, description: "Presente", date: "12/04/2023", tag: "Gasto"),
//    HistoryItemModel(amount: -4.40, description: "Ônibus", date: "10/04/2023", tag: "Gasto"),
//    HistoryItemModel(amount: -20.00, description: "Cinema", date: "10/04/2023", tag: "Gasto"),
//    HistoryItemModel(amount: -4.40, description: "Ônibus", date: "10/04/2023", tag: "Gasto"),
//    HistoryItemModel(amount: -10.0, description: "Brinquedo", date: "05/04/2023", tag: "Gasto"),
    
    func getHistory() async {
        await history = HistoryService().getHistory()
    }
}


//MARK - SERVICE
class HistoryService {
    
    let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6Ijc4ODg2MGUyLTlhYjMtNDM5Yy05NGQyLWRiZjllMTRmYmM1NSIsImlhdCI6MTY4Mzc1NjM2MSwiZXhwIjoxNjgzODQyNzYxLCJzdWIiOiI3ODg4NjBlMi05YWIzLTQzOWMtOTRkMi1kYmY5ZTE0ZmJjNTUifQ.zfk7-sK2zKB6dId1pj9p2ikOlCrOywuRk8TlMXZFqbM"
    
    func getHistory() async -> [HistoryItemModel] {
        var history: [HistoryItemModel] = []
        
        let fullUrl = "https://jab-api-xh0g.onrender.com/api/v1/movimentations"
        guard let url = URL(string: fullUrl) else { return history }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let decodedResponse = try JSONDecoder().decode(WalletModel.self, from: data)
            history = decodedResponse.history
        } catch {
            print(error.localizedDescription)
        }
        
        return history
    }
}



//MARK - VIEW
struct HistoryView: View {
    @StateObject var historyViewModel = HistoryViewModel()
    
    var body: some View {
        
        VStack{
            Title()
            History()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .ignoresSafeArea(edges: .bottom)
        .toolbarBackground(Color.purple, for: .navigationBar)
        .environmentObject(historyViewModel)
        .task {
            await historyViewModel.getHistory()
        }
        .refreshable {
            await historyViewModel.getHistory()
        }
    }
}

struct History_Preview: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            HistoryView()
        }
    }
}

struct Title: View {
    @EnvironmentObject var historyViewModel: HistoryViewModel
    
    var body: some View {
        VStack {
            Text("Histórico")
                .font(Font.system(Font.TextStyle.largeTitle, weight: Font.Weight.bold))
                .frame(maxWidth: .infinity, alignment: .center)
                .foregroundColor(.black)
                .padding(.bottom, 3)
            
            
            Text("Aqui você pode acompanhar o histórico \n de movimentações da sua carteira.")
                .font(.system(.footnote))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            
        }
        .frame(maxWidth: .infinity)
        .background(
            Circle()
                .fill(.purple.gradient)
                .frame(width: 600, height: 600)
                .shadow(radius: 10)
                .padding(.top, -450)
        )
        .zIndex(1)
        //.padding(.top, -50)
    }
}

struct History: View {
    @EnvironmentObject var historyViewModel: HistoryViewModel
    
    var body: some View {
        GeometryReader { proxy in
            ScrollView {
    //            Rectangle()
    //                .fill(.clear)
    //                .frame(width: .infinity, height: 70)
                if(historyViewModel.history.count == 0){
                    Text("Não há histórico para essa carteira")
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.gray)
                        .padding(.top, proxy.size.height * 0.4)
                } else {
                    ForEach(historyViewModel.history, id: \.id) { historyItem in
                        WalletHistoryItem(amount: historyItem.amount, description: historyItem.description, date: historyItem.date, tag: historyItem.tag)
                    }
                }
            }
            .padding(EdgeInsets(top: 40, leading: 20, bottom: 25, trailing: 20))
            .scrollIndicators(.hidden)
        }
        
    }
}
