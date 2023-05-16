//
//  ContentView.swift
//  Pocket Money
//
//  Created by Dyan on 5/3/23.
//

import SwiftUI

struct ContentView: View {
    @State var viewModel = ContentViewModel()
    @EnvironmentObject var singInViewModel: SignInViewModel
    
    var body: some View {
        NavigationStack{
            if singInViewModel.userIsAuthenticated {
                if(singInViewModel.parent){
                    ListOfChildrenView()
                } else {
                    WalletView()
                }
            }else {
                VStack {
                    CarouselImageText(viewModel: $viewModel)
                    Spacer()
                    ButtonsSingInSinUp()
                }
                .padding()
            }
       
        }
       
    }
}

struct ContentView_Previews: PreviewProvider {
    static let transactionListVM: SignInViewModel = {
        let transactionListVM = SignInViewModel()
        return transactionListVM
    }()
    static let registeredChildrenViewModel: ListOfChildrenViewModel = {
        let transactionListVM = ListOfChildrenViewModel()
        return transactionListVM
    }()
    static var previews: some View {
        ContentView()
            .environmentObject(transactionListVM)
            .environmentObject(registeredChildrenViewModel)
    }
}

struct CarouselImageText: View {
    @Binding var viewModel: ContentViewModel
    
    var body: some View {
        VStack{
            Image(viewModel.carousel[viewModel.index].name)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 300, maxHeight: 300)
            
            HStack {
                ForEach(viewModel.carousel) { carousel in
                    Capsule()
                        .frame(width: viewModel.index == carousel.styleValue ? 48 : 24, height: 8)
                        .foregroundColor(.purple)
                        .opacity(viewModel.index == carousel.styleValue ? 1 : 0.5)
                }
            }
            Text(viewModel.carousel[viewModel.index].text)
                .font(.title)
                .fontWeight(.medium)
                .foregroundColor(Color(.darkText))
        }
        .onTapGesture {  viewModel.index += viewModel.index == 1 ? -1 : +1; viewModel.transitionAnimation -= 100.0}
        .animation(Animation.easeInOut(duration: 1.0), value: viewModel.transitionAnimation)
    }
}

struct ButtonsSingInSinUp: View {
    var body: some View {
        VStack{
            NavigationLink(destination: {
                SignInView()
            }, label: {
                Text("Já tenho cadastro")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .maximum(300, 300))
                    .padding(4)
            })
            .buttonStyle(.borderedProminent)
            .tint(.purple)
            .padding(.bottom)
            
            NavigationLink("Não tenho conta", destination: SignUpView())
                .foregroundColor(.purple)
                .fontWeight(.semibold)
    
        }
        
    }
}
