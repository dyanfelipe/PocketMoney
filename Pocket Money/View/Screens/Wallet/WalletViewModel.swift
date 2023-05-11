//
//  WalletViewModel.swift
//  Pocket Money
//
//  Created by Rodrigo Oliveira on 11/05/23.
//

import Foundation

class WalletViewModel: ObservableObject {
    @Published var parent: Bool = UserDefaults.standard.bool(forKey: "parent")
    @Published var walletData = WalletModel()
    @Published var isPresentRecordExpenses = false
    
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
