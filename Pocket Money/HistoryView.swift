//
//  WalletStatementView.swift
//  Pocket Money
//
//  Created by Rodrigo Oliveira on 07/05/23.
//

import SwiftUI

//MARK - MODEL
struct HistoryItemModel: Identifiable {
    let amount: String
    let description: String
    let date: String
    let tag: String
    var id: String {amount + description + date + tag}
}


//MARK - VIEW MODEL
struct HistoryViewModel {
    let history = [
        HistoryItemModel(amount: "- R$ 35,00", description: "Lanche", date: "05/05/2023", tag: "💸 Gasto"),
        HistoryItemModel(amount: "- R$ 12,00", description: "Sorvete", date: "01/05/2023", tag: "Gasto"),
        HistoryItemModel(amount: "+ R$ 80,00", description: "", date: "20/04/2023", tag: "Guardado"),
        HistoryItemModel(amount: "+ R$ 150,00", description: "Mesada", date: "20/04/2023", tag: "Depósito"),
        HistoryItemModel(amount: "- R$ 18,00", description: "Uber", date: "13/04/2023", tag: "Gasto"),
        HistoryItemModel(amount: "- R$ 5,00", description: "Chocolate", date: "13/04/2023", tag: "Gasto"),
        HistoryItemModel(amount: "- R$ 31,00", description: "Presente", date: "12/04/2023", tag: "Gasto"),
        HistoryItemModel(amount: "- R$ 4,40", description: "Ônibus", date: "10/04/2023", tag: "Gasto"),
        HistoryItemModel(amount: "- R$ 20,00", description: "Cinema", date: "10/04/2023", tag: "Gasto"),
        HistoryItemModel(amount: "- R$ 4,40", description: "Ônibus", date: "10/04/2023", tag: "Gasto"),
        HistoryItemModel(amount: "- R$ 10,00", description: "Brinquedo", date: "05/04/2023", tag: "Gasto"),
    ]
}


//MARK - VIEW
struct HistoryView: View {
    var body: some View {
        VStack{
            
            
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
            
            
            
            ScrollView {
                Rectangle()
                    .fill(.clear)
                    .frame(width: .infinity, height: 70)
                ForEach(HistoryViewModel().history) { historyItem in
                    WalletHistoryItem(amount: historyItem.amount, description: historyItem.description, date: historyItem.date, tag: historyItem.tag)
                }
            }
            .padding(EdgeInsets(top: -40, leading: 20, bottom: 0, trailing: 20))
            .scrollIndicators(.hidden)
            
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .ignoresSafeArea(edges: .bottom)
    }
}

struct History_Preview: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
