//
//  ChildHome.swift
//  Pocket Money
//
//  Created by Rodrigo Oliveira on 06/05/23.
//

import SwiftUI


//MARK - VIEW
struct ChildWalletView: View {
    
    var body: some View {
        VStack{
            WalletDataView()
            ActionsButtonsView()
            WalletStatementView()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding(20)
        .ignoresSafeArea(edges: .bottom)
        
    }
    
}

struct ChildWallet_Previews: PreviewProvider {
    static var previews: some View {
        ChildWalletView()
    }
}


struct WalletDataView: View {
    var body: some View {
        VStack {
            Text("Carteira")
                .font(Font.system(Font.TextStyle.largeTitle, weight: Font.Weight.bold))
                .frame(maxWidth: .infinity, alignment: .center)
                .foregroundColor(.black)
                .padding(.bottom, 20)
            
            Text("Valor para gastar")
                .font(Font.system(Font.TextStyle.callout))
                .foregroundColor(.white)
            
            Text("R$ 250,00")
                .font(Font.system(Font.TextStyle.largeTitle, weight: Font.Weight.bold))
                .foregroundColor(Color.white)
                .shadow(color: Color.black, radius: 5)
                .padding(.bottom, 5)
            
            Text("Valor guardado")
                .font(Font.system(Font.TextStyle.callout))
                .foregroundColor(.white)
            
            Text("R$ 510,00")
                .font(Font.system(Font.TextStyle.title, weight: Font.Weight.semibold))
                .foregroundColor(Color.white)
                .shadow(color: Color.black, radius: 5)
        }
        .background(BgDataWallet())
    }
}

struct BgDataWallet: View {
    var body: some View {
        Circle()
            .fill(.purple.gradient)
            .frame(width: 500, height: 500)
            .shadow(radius: 10)
            .padding(.top, -100)
    }
}

struct ActionsButtonsView: View {
    var body: some View {
        HStack {
            ActionButton(emoji: "💸", sfSimbolName: nil, text: "REGISTRAR GASTO")
                .padding(.top, -40)
            
            Spacer()
            
            ActionButton(emoji: nil, sfSimbolName: "list.bullet", text: "EXTRATO")
                .padding(.top, 40)
            
            Spacer()
            
            ActionButton(emoji: "💰", sfSimbolName: nil, text: "GUARDAR DINHEIRO")
                .padding(.top, -40)
        }
        .frame(maxWidth: .infinity, minHeight: 150, alignment: .top)
    }
}

struct ActionButton: View {
    let emoji: String?
    let sfSimbolName: String?
    let text: String
    
    var body: some View {
        VStack(spacing: 5) {
            if(sfSimbolName == nil){
                Text(emoji!)
                    .font(.system(size: 30))
                    .shadow(radius: 5)
            }else if(emoji == nil){
                Image(systemName: sfSimbolName!)
                    .font(.system(size: 30))
                    .shadow(radius: 5)
                    .padding(.bottom, 5)
            }
            
            Text(text)
                .font(Font.system(Font.TextStyle.caption2, weight: .bold))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: 90, maxHeight:90, alignment: .center)
        .foregroundColor(Color.white)
        .background(Color.darkPurple)
        .cornerRadius(100)
        .shadow(color:.black, radius: 10)
    }
}

struct WalletStatementItem: View {
    let amount: String
    let description: String
    let tag: String
    
    var body: some View {
        HStack {
            VStack {
                Text(amount)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.system(.headline))
                    .foregroundColor(amount.contains("-") ? .red : .green)
                Text(description)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(Font.system(Font.TextStyle.caption))
                    .foregroundColor(.gray7)
                    .padding(.leading, 12)
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

struct WalletStatementView: View {
    var body: some View {
        VStack {
            Text("Extrato")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(Font.system(Font.TextStyle.title, weight: Font.Weight.bold))
            
            Text("5 últimas movimentações")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(Font.system(Font.TextStyle.caption))
                .foregroundColor(.gray7)
                .padding(.bottom, 5)
            
            ScrollView {
                WalletStatementItem(amount: "- R$ 35,00", description: "Lanche", tag: "Gasto")
                WalletStatementItem(amount: "- R$ 12,00", description: "Sorvete", tag: "Gasto")
                WalletStatementItem(amount: "+ R$ 80,00", description: "", tag: "Guardado")
                WalletStatementItem(amount: "+ R$ 150,00", description: "Mesada", tag: "Depósito")
                WalletStatementItem(amount: "- R$ 18,00", description: "Uber", tag: "Gasto")
            }
            .scrollIndicators(.hidden)

        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
