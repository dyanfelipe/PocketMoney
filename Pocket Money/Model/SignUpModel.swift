//
//  SignUpModel.swift
//  Pocket Money
//
//  Created by Dyan on 5/15/23.
//

import Foundation


enum Profile: String, CaseIterable, Identifiable {
    case father = "pai", mother = "mãe", son = "Filho"
    var id: Self { self }
}

struct CreatedAccount: Codable {
    var name:String = ""
    var email: String = ""
    var password: String = ""
    var confirmPassword: String = ""
    
    enum CodingKeys: String, CodingKey {
        case name
        case email
        case password
        case confirmPassword = "passwordConfirmation"
   }
}

struct APIError: Codable {
    var statusCode: Int
    var message: String
    var description: String
    var timestamp: String
}

struct AlertSingUp: Codable {
    var message: String
    var description: String
}

struct CreateAccountAuthUser: Decodable {
    let email: String
    let confirmPassword: String
    let id: Int
}


struct CreateAccountAuth: Decodable {
    var id: String
    var name: String
    var email: String
    
    
     enum CodingKeys: String, CodingKey {
         case id
         case name
         case email
    }
}
