//
//  MoneyMovementModel.swift
//  Pocket Money
//
//  Created by Dyan on 5/15/23.
//

import Foundation

struct Movimentation: Codable {
    let id: String
    let description: String
    let value: Int
    let type: String
    let kidId: String
    let createdAt: String
    let updatedAt: String
}

struct MovimentationRequest: Codable {
    var description = String()
    var value = String()
    var type = String()
}


class TextBindingManager: ObservableObject {
    @Published var text = "" {
        didSet {
            if text.count > characterLimit && oldValue.count <= characterLimit {
                text = oldValue
            }
        }
    }
    let characterLimit: Int

    init(limit: Int = 5){
        characterLimit = limit
    }
}

enum TypeMovement: String {
    case spent = "Gasto"
    case saveMoney = "Guardado"
    case deposit = "Depósito"
    case withdraw = "Sacar"
}

enum TitlePages: String {
    case titleRecordExpenses = "Registrar Gastos"
    case titleSaveMoney = "Guardar Dinheiro"
    case titleDeposit = "Depositar"
    case titleWithdraw = "Sacar"
}
