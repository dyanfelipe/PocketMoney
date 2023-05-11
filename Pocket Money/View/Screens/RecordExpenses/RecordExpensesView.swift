//
//  RecordExpensesView.swift
//  Pocket Money
//
//  Created by Rodrigo Oliveira on 11/05/23.
//

import SwiftUI

struct RecordExpenses: View {
    @State var amount = String()
    @State var description = String()

    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ScrollView(.vertical) {
                    VStack{
                        HStack{
                            Image(systemName: "dollarsign")
                                .foregroundColor(.purple)
                            TextField("Valor", text: $amount)
                                .fontWeight(.medium)
                        }
                        .textFieldBorderIcon()
                        
                        HStack{
                            Image(systemName: "note.text")
                                .foregroundColor(.purple)
                            TextField("Descrição", text: $description)
                                .fontWeight(.medium)
                        }
                        .textFieldBorderIcon()
                    
                        Button {
                            Task{
                                //await viewModel.createChild()
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
                .navigationTitle("Registrar Gasto")
                .navigationBarTitleDisplayMode(.large)
//                .toolbar{
//                    ToolbarItem(placement: .navigationBarLeading) {
//                        Button {
//                            //viewModel.showSheetToggle()
//                        } label: {
//                            Image(systemName: "chevron.backward")
//                                .fontWeight(.bold)
//                        }
//                    }
//                }
            }
        }
    }
}

struct RecordExpenses_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            RecordExpenses()
        }
    }
}
