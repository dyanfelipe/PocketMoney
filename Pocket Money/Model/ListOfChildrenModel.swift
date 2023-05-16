//
//  ListOfChildrenModel.swift
//  Pocket Money
//
//  Created by Dyan on 5/15/23.
//

import Foundation

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
