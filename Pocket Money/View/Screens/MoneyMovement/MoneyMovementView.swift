//
//  RecordExpensesView.swift
//  Pocket Money
//
//  Created by Rodrigo Oliveira on 11/05/23.
//

import SwiftUI

struct MoneyMovementPerUser: View {
    @ObservedObject var description = TextBindingManager(limit: 137)
    @EnvironmentObject var singInViewModel: SignInViewModel
    @StateObject var moneyMovementViewModel = MoneyMovementViewModel()
    var id: String
    var typeMovement: TypeMovement
    var title: TitlePages
    @State private var type = String()
    @State private var isSubtitleHidden = false
    @State private var value = 0
    
    private var numberFormatter: NumberFormatter
    
    init(numberFormatter: NumberFormatter = NumberFormatter(), id: String?, typeMovement: TypeMovement?, title: TitlePages) {
        self.numberFormatter = numberFormatter
        self.numberFormatter.locale = Locale(identifier: "pt_BR")
        self.numberFormatter.numberStyle = .currency
        self.numberFormatter.maximumFractionDigits = 2
        
        self.id = id ?? String()
        self.typeMovement = typeMovement ?? .spent
        self.title = title
    }

    
    var body: some View {
        NavigationStack{
            GeometryReader { geometry in
                ScrollView(.vertical) {
                    VStack{
                        HStack{
                            Image(systemName: "dollarsign")
                                .foregroundColor(.purple)
                            CurrencyTextField(numberFormatter: numberFormatter, value: $value)
                                          .frame(height: 4)
                                      Rectangle()
                                          .frame(width: 0, height: 10)
                        }
                        .textFieldBorderIcon()
                        HStack{
                            Image(systemName: "note.text")
                                .foregroundColor(.purple)
                            TextField("Descrição", text: $moneyMovementViewModel.movimentationRequest.description, axis: .vertical)
                                .lineLimit(4)
                                .fontWeight(.medium)
                        }
                        .textFieldBorderIcon()
                        
                        Button {
                            Task{
                                moneyMovementViewModel.movimentationRequest.type = typeMovement.rawValue
                                moneyMovementViewModel.movimentationRequest.value = String(Double(value) / 100)
                                await moneyMovementViewModel.movimentation(id: id)
                            }
                        } label: {
                            Text("Registrar")
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(4)
                        }
                        .padding(.horizontal, 20)
                        .buttonStyle(.borderedProminent)
                        .tint(.purple)
                        .padding(.vertical)
                    }
                    .frame(width: geometry.size.width)
                    .frame(minHeight: geometry.size.height)
                }
                .navigationTitle(title.rawValue)
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}

struct MoneyMovement_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            MoneyMovementPerUser(id: "", typeMovement: .spent, title: .titleRecordExpenses)
        }
    
    }
}

