//
//  Utils.swift
//  Pocket Money
//
//  Created by Rodrigo Oliveira on 10/05/23.
//

import Foundation

class Utils {
    
    func formatNumberToReal(value: Double) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale(identifier: "pt_BR")
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: value)) ?? "0.0"
    }
    
    func formatDate(dateString: String) -> String {
        let dateFormatterInput = DateFormatter()
        dateFormatterInput.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if let date = dateFormatterInput.date(from: dateString) {
            let dateFormatterOutput = DateFormatter()
            dateFormatterOutput.dateFormat = "dd/MM/yyyy"
            return dateFormatterOutput.string(from: date)
        }
        return "Não foi possivel formatar a data"
    }
    
}
