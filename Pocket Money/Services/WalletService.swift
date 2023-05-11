//
//  WalletService.swift
//  Pocket Money
//
//  Created by Rodrigo Oliveira on 11/05/23.
//

import Foundation

class WalletService {
    
    let token = UserDefaults.standard.string(forKey: "token") ?? ""
    
    func getWallet(chielId: String?) async -> WalletModel {
        var wallet = WalletModel()
        var fullUrl = String()
        
        if let id = chielId {
            fullUrl = "https://jab-api-xh0g.onrender.com/api/v1/parents/children/\(id)"
        } else {
            fullUrl = "https://jab-api-xh0g.onrender.com/api/v1/kids"
        }
        
        guard let url = URL(string: fullUrl) else { return wallet }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let decodedResponse = try JSONDecoder().decode(WalletModel.self, from: data)
            wallet = decodedResponse
        } catch {
            print(error.localizedDescription)
        }
        return wallet
    }
}
