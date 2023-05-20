//
//  ChildHome.swift
//  Pocket Money
//
//  Created by Rodrigo Oliveira on 06/05/23.
//

import SwiftUI

struct WalletView: View {
    @StateObject var wallet = WalletViewModel()
    @EnvironmentObject var singInViewModel: SignInViewModel
    var childId: String?
    
    var body: some View {
        VStack{
            WalletData()
            ActionsButtons(childId: childId)
            WalletHistory()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
        .ignoresSafeArea(edges: .bottom)
        .navigationBarBackButtonHidden(wallet.parent ? false : true)
        .toolbar{
            ToolbarItem(placement: .navigationBarLeading) {
                if(!wallet.parent){
                    
                    Button {
                        singInViewModel.userIsAuthenticated = false
                        singInViewModel.token = ""
                    } label: {
                        ToolBarButton(imageName: "arrow.backward.square")
                    }
                }
            }
        }
        .toolbar{
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    Task{
                        await wallet.getWallet(chielId: childId)
                    }
                } label: {
                    ToolBarButton(imageName: "arrow.clockwise")
                }
            }
            
        }
        .navigationBarTitleDisplayMode(.automatic) // TODO: automatico mostra o sheet em prwview o inline nao
        .environmentObject(wallet)
        .onAppear {
            Task{
                await wallet.getWallet(chielId: childId)
            }
        }
        .sheet(isPresented: $wallet.isPresentRecordExpenses) {
            MoneyMovementPerUser(id: childId, typeMovement: .spent, title: .titleRecordExpenses)
        }
        .sheet(isPresented: $wallet.isPresentSaveMoney) {
            MoneyMovementPerUser(id: childId, typeMovement: .saveMoney, title: .titleSaveMoney)
        }
        
        .sheet(isPresented: $wallet.isPresentDeposit) {
            MoneyMovementPerUser(id: childId, typeMovement: .deposit, title: .titleDeposit)
        }
        
        .sheet(isPresented: $wallet.isPresentWithdraw) {
            MoneyMovementPerUser(id: childId, typeMovement: .withdraw, title: .titleWithdraw)
        }
    }
    
}

struct Teste: View {
    var body: some View {
        HStack {
        Image(systemName: "chevron.backward") // BackButton Image
                .fontWeight(.bold)
            Text("Sair") //translated Back button title
        }
        .foregroundColor(.gray7)
    }
}

// TODO: Botao nativo navigationBar esta azul validar se vai criar um novo buttom ou vai usar ele.
struct Wallet_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            WalletView()
        }
    }
}

struct ToolBarButton: View {
    let imageName: String
    
    var body: some View {
        Image(systemName: imageName)
            .font(.system(.title3, weight: .bold))
            .foregroundColor(.black)
            .shadow(color: .white, radius: 5)
    }
}


struct WalletData: View {
    @EnvironmentObject var wallet: WalletViewModel
    
    var body: some View {
        VStack {
            Text("Carteira")
                .font(Font.system(Font.TextStyle.largeTitle, weight: Font.Weight.bold))
                .frame(maxWidth: .infinity, alignment: .center)
                .foregroundColor(.black)
                .padding(.bottom, wallet.parent ? 0 : 20)
            
            if(wallet.parent){
                Text(wallet.walletData.name)
                    .font(.system(.body, weight: .semibold))
                    .shadow(color: .white, radius: 10)
                    .padding(.bottom, wallet.parent ? 10 : 0)
            }
            
            Text("Valor para gastar")
                .font(Font.system(Font.TextStyle.callout))
                .foregroundColor(.white)
            
            Text("R$ \(Utils().formatNumberToReal(value: wallet.walletData.amountToSpend))")
                .font(Font.system(Font.TextStyle.largeTitle, weight: Font.Weight.bold))
                .foregroundColor(Color.white)
                .shadow(color: Color.black, radius: 5)
                .padding(.bottom, 5)
            
            Text("Valor guardado")
                .font(Font.system(Font.TextStyle.callout))
                .foregroundColor(.white)
            
            Text("R$ \(Utils().formatNumberToReal(value:  wallet.walletData.savedValue))")
                .font(Font.system(Font.TextStyle.title, weight: Font.Weight.semibold))
                .foregroundColor(Color.white)
                .shadow(color: Color.black, radius: 5)
        }
        .background(
            Circle()
                .fill(.purple.gradient)
                .frame(width: 500, height: 500)
                .shadow(radius: 10)
                .padding(.top, -150)
        )
        //.padding(.top, -50)
    }
}

struct ActionsButtons: View {
    @EnvironmentObject var wallet: WalletViewModel
    var childId: String?
    
    var body: some View {
        HStack {
            
            if(wallet.parent){
                Button {
                    wallet.isPresentDeposit.toggle()
                } label: {
                    ActionButton(emoji: "💵", sfSimbolName: nil, text: "DEPOSITAR")
                        .padding(.top, -50)
                }
            } else {
                Button {
                    wallet.isPresentRecordExpenses.toggle()
                } label: {
                    ActionButton(emoji: "💸", sfSimbolName: nil, text: "REGISTRAR GASTO")
                        .padding(.top, -50)
                }
            }
            
            Spacer()
            
            NavigationLink {
                HistoryView(childId: childId)
            } label: {
                ActionButton(emoji: nil, sfSimbolName: "list.bullet", text: "HISTÓRICO")
                    .padding(.top, 30)
            }
            
            Spacer()
            
            if(wallet.parent){
                Button {
                    wallet.isPresentWithdraw.toggle()
                } label: {
                    ActionButton(emoji: "💸", sfSimbolName: nil, text: "SACAR")
                        .padding(.top, -50)
                }
            } else {
                Button {
                    wallet.isPresentSaveMoney.toggle()
                } label: {
                    ActionButton(emoji: "💰", sfSimbolName: nil, text: "GUARDAR DINHEIRO")
                        .padding(.top, -50)
                }
            }
        }
        .frame(maxWidth: .infinity, minHeight: 130, alignment: .top)
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

struct WalletHistory: View {
    @EnvironmentObject var wallet: WalletViewModel
    
    var body: some View {
        GeometryReader { proxy in
            VStack {
                Text("Histórico")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(Font.system(Font.TextStyle.title, weight: Font.Weight.bold))
                
                Text("5 últimas movimentações")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(Font.system(Font.TextStyle.caption))
                    .foregroundColor(.gray7)
                    .padding(.bottom, 5)
                
                
                ScrollView {
                    if(wallet.walletData.history.count == 0){
                        Text("Não há histórico para essa carteira")
                            .foregroundColor(.gray)
                            .padding(.top, proxy.size.height * 0.3)
                    } else {
                        ForEach(wallet.walletData.history, id: \.id) { historyItem in
                            WalletHistoryItem(amount: historyItem.amount, description: historyItem.description, date: historyItem.date, tag: historyItem.tag)
                        }
                    }
                }
                .scrollIndicators(.hidden)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
