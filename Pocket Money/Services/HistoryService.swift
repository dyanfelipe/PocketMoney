//
//  HistoryService.swift
//  Pocket Money
//
//  Created by Rodrigo Oliveira on 11/05/23.
//

import Foundation

class HistoryService {
    
    let token = UserDefaults.standard.string(forKey: "token") ?? ""
    
    func getHistory(childId: String?) async -> [HistoryItemModel] {
        var history: [HistoryItemModel] = []
        var fullUrl = String()
        
        if let id = childId {
            fullUrl = "https://jab-api-xh0g.onrender.com/api/v1/movimentations/\(id)"
        } else {
            fullUrl = "https://jab-api-xh0g.onrender.com/api/v1/movimentations"
        }
        
        guard let url = URL(string: fullUrl) else { return history }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let decodedResponse = try JSONDecoder().decode(WalletModel.self, from: data)
            history = decodedResponse.history
        } catch {
            print(error.localizedDescription)
        }
        
        return history
    }
}
