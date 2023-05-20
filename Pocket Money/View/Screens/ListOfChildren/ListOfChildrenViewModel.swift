//
//  ListOfChildrenViewModel.swift
//  Pocket Money
//
//  Created by Dyan on 5/15/23.
//

import Foundation
import SwiftUI

class ListOfChildrenViewModel: ObservableObject {
    var child = NewChild()
    @Published var showSheet: Bool = false
    @Published var childs: [Childs] = []
    let token = UserDefaults.standard.string(forKey: "token") ?? ""
    
     func showSheetToggle() {
        self.showSheet.toggle()
    }
    
    func getChilds() async {
        let fullUrl = "https://jab-api-xh0g.onrender.com/api/v1/parents/children"
        guard let url = URL(string: fullUrl) else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let decodedResponse = try JSONDecoder().decode([Childs].self, from: data)
            DispatchQueue.main.async {
                self.childs = decodedResponse
            }
            
        }catch {
            print("error")
        }
    }
    
    func createChild() async {
        guard let encoded = try? JSONEncoder().encode(child) else { return }
        guard let url = URL(string: "https://jab-api-xh0g.onrender.com/api/v1/kids") else {return}
        var request = URLRequest(url: url)
        let authorizationKey = "Bearer ".appending(token)
        request.setValue(authorizationKey, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        do {
            let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
            let userCreated = try JSONDecoder().decode(RaisedChild.self, from: data)
            await getChilds()
            showSheetToggle()
        } catch  {
            print(String(describing: error))
        }
    }
    
    func convetRealToCentsDecimal(savedValueD: String, amountToSpendD: String) -> String {
        let savedValueD = Double(savedValueD) ?? 0.0
        let amountToSpendD = Double(amountToSpendD) ?? 0.0
        let sumDouble = ((savedValueD + amountToSpendD) / 100) * 100
        let newValue = formatNumberToReal(value: sumDouble)
        return newValue
    }
    
    func convetRealToCentsDecimal(value: String) -> String {
        let value = Double(value) ?? 0.0
        let valueNewFormatted = (value / 100) * 100
        let newValue = formatNumberToReal(value: valueNewFormatted)
        return newValue
    }
    
    func formatNumberToReal(value: Double) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale(identifier: "pt_BR")
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: value)) ?? "0.0"
    }
}
