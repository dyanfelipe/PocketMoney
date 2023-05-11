//
//  WalletStatementView.swift
//  Pocket Money
//
//  Created by Rodrigo Oliveira on 07/05/23.
//

import SwiftUI

//MARK - VIEW
struct HistoryView: View {
    @StateObject var historyViewModel = HistoryViewModel()
    var childId: String?
    
    var body: some View {
        
        VStack{
            Title()
            History()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .ignoresSafeArea(edges: .bottom)
        .toolbarBackground(Color.purple, for: .navigationBar)
        .environmentObject(historyViewModel)
        .onAppear {
            Task {
                await historyViewModel.getHistory(childId: childId)
            }
        }
        .refreshable {
            await historyViewModel.getHistory(childId: childId)
        }
    }
}

struct History_Preview: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            HistoryView()
        }
    }
}

struct Title: View {
    @EnvironmentObject var historyViewModel: HistoryViewModel
    
    var body: some View {
        VStack {
            Text("Histórico")
                .font(Font.system(Font.TextStyle.largeTitle, weight: Font.Weight.bold))
                .frame(maxWidth: .infinity, alignment: .center)
                .foregroundColor(.black)
                .padding(.bottom, 3)
            
            
            Text("Aqui você pode acompanhar o histórico \n de movimentações da sua carteira.")
                .font(.system(.footnote))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            
        }
        .frame(maxWidth: .infinity)
        .background(
            Circle()
                .fill(.purple.gradient)
                .frame(width: 600, height: 600)
                .shadow(radius: 10)
                .padding(.top, -450)
        )
        .zIndex(1)
        //.padding(.top, -50)
    }
}

struct History: View {
    @EnvironmentObject var historyViewModel: HistoryViewModel
    
    var body: some View {
        GeometryReader { proxy in
            ScrollView {
    //            Rectangle()
    //                .fill(.clear)
    //                .frame(width: .infinity, height: 70)
                if(historyViewModel.history.count == 0){
                    Text("Não há histórico para essa carteira")
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.gray)
                        .padding(.top, proxy.size.height * 0.4)
                } else {
                    ForEach(historyViewModel.history, id: \.id) { historyItem in
                        WalletHistoryItem(amount: historyItem.amount, description: historyItem.description, date: historyItem.date, tag: historyItem.tag)
                    }
                }
            }
            .padding(EdgeInsets(top: 40, leading: 20, bottom: 25, trailing: 20))
            .scrollIndicators(.hidden)
        }
        
    }
}
