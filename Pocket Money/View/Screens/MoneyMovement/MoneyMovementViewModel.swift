//
//  MoneyMovementViewModel.swift
//  Pocket Money
//
//  Created by Dyan on 5/15/23.
//

import Foundation

class MoneyMovementViewModel: ObservableObject {
    var movimentationRequest = MovimentationRequest()
    var baseURL = "https://jab-api-xh0g.onrender.com/api/v1/movimentations"
    let parent = UserDefaults.standard.bool(forKey: "parent")
    let token = UserDefaults.standard.string(forKey: "token") ?? ""
    
    func movimentation(id: String?) async {
        var requestURL = self.baseURL
        guard let encoded = try? JSONEncoder().encode(movimentationRequest) else {
            print("Failed to encode order")
            return
        }
        print(String(data: encoded, encoding: .utf8))
        
        if let hasId = id {
            requestURL = "\(requestURL)/\(hasId)"
        }
        print(String(describing: requestURL))
        guard let url = URL(string: requestURL) else {return}
        var request = URLRequest(url: url)
        let authorizationKey = "Bearer ".appending(token)
        request.setValue(authorizationKey, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        do {
            let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
            print(String(data: data, encoding: .utf8))
//            let movimentation = try JSONDecoder().decode(Movimentation.self, from: data)
//            print(movimentation)
        } catch  {
            print(String(describing: error))
//            print(error.localizedDescription)
        }
    }
}
