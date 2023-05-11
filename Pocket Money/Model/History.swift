//
//  History.swift
//  Pocket Money
//
//  Created by Rodrigo Oliveira on 11/05/23.
//

import Foundation

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
