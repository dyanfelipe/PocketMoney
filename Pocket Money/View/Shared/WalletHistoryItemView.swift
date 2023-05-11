//
//  WalletHistoryItemView.swift
//  Pocket Money
//
//  Created by Rodrigo Oliveira on 11/05/23.
//

import SwiftUI

struct WalletHistoryItem: View {
    let amount: Double
    let description: String
    let date: String
    let tag: String
    
    var body: some View {
        HStack {
            VStack {
                Text(
                    ((tag == "Gasto" || tag == "Saque") ? "-" : "+") +
                    " R$ \(Utils().formatNumberToReal(value: amount))"
                )
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.system(.headline))
                .foregroundColor((tag == "Gasto" || tag == "Saque") ? .red : .green)
                
                if(description != ""){
                    Text(description)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(Font.system(Font.TextStyle.caption))
                        .foregroundColor(.gray7)
                        .padding(.leading, (tag == "Gasto" || tag == "Saque") ? 12 : 15)
                }
                
                Text(Utils().formatDate(dateString: date))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(Font.system(Font.TextStyle.caption))
                    .foregroundColor(.gray)
                    .padding(.leading, (tag == "Gasto" || tag == "Saque") ? 12 : 15)
                
                if(description == ""){
                    Text("")
                }
            }
            .padding()
            
            Text(tag)
                .font(.system(.subheadline, weight: .semibold))
                .padding(2)
                .frame(maxWidth: 100)
                .background(.purple)
                .foregroundColor(.white)
                .cornerRadius(5)
                .padding()
            
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.gray.opacity(0.1))
        .cornerRadius(5)
    }
}
