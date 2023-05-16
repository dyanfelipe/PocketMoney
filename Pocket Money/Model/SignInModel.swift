//
//  SignInModel.swift
//  Pocket Money
//
//  Created by Dyan on 5/15/23.
//

import Foundation


struct SingInAccount: Codable {
    var email: String = ""
    var password: String = ""
}

struct User: Decodable {
    let email: String
    let firstName: String
    let lastName: String
    let age: Int
    let id: Int
    
     enum CodingKeys: String, CodingKey {
        case email
        case firstName = "firstname"
        case lastName = "lastname"
        case age
        case id
    }
}

struct Auth: Decodable {
    let accessToken: String
    let parent: Bool
    
    enum CodingKeys: String, CodingKey{
        case accessToken = "token"
        case parent
    }
}
