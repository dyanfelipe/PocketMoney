//
//  HistoryViewModel.swift
//  Pocket Money
//
//  Created by Rodrigo Oliveira on 11/05/23.
//

import Foundation

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
    
    func getHistory(childId: String?) async {
        await history = HistoryService().getHistory(childId: childId)
    }
}
