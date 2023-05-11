//
//  Wallet.swift
//  Pocket Money
//
//  Created by Rodrigo Oliveira on 11/05/23.
//

import Foundation

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
