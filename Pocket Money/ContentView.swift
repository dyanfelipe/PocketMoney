//
//  ContentView.swift
//  Pocket Money
//
//  Created by Dyan on 5/3/23.
//

import SwiftUI

struct Carousel: Identifiable {
    let name: String
    let text: String
    let styleValue: Int
    var id: String { name }
}

struct ContentView: View {
    var body: some View {
        NavigationStack{
            VStack {
                CarouselImageText()
                Spacer()
                ButtonsSingInSinUp()
            }
            .padding()
        }
       
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct CarouselImageText: View {
    @State private var index = 0
    @State private var transitionAnimation: CGFloat = 200.0
    
    let carousel = [
        Carousel(name: "money.bag", text: "O conhecimento começa pequeno", styleValue: 0),
        Carousel(name: "money.safe", text: "Vamos enteder \n  o que é valor", styleValue: 1)
    ]
    
    var body: some View {
        VStack{
            Image(carousel[index].name)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 300, maxHeight: 300)
            
            HStack {
                ForEach(carousel) { carousel in
                    Capsule()
                        .frame(width: index == carousel.styleValue ? 48 : 24, height: 8)
                        .foregroundColor(.purple)
                        .opacity(index == carousel.styleValue ? 1 : 0.5)
                }
            }
            Text(carousel[index].text)
                .font(.title)
                .fontWeight(.medium)
                .foregroundColor(Color(.darkText))
        }
        .onTapGesture {  index += index == 1 ? -1 : +1; transitionAnimation -= 100.0}
        .animation(Animation.easeInOut(duration: 1.0), value: transitionAnimation)
    }
}

struct ButtonsSingInSinUp: View {
    var body: some View {
        VStack{
            NavigationLink(destination: {
                SingIn()
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
            
            NavigationLink("Não tenho conta", destination: SignUp())
                .foregroundColor(.purple)
                .fontWeight(.semibold)
    
        }
        
    }
}
