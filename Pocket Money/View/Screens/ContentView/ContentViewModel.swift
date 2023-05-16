//
//  ContentViewModel.swift
//  Pocket Money
//
//  Created by Dyan on 5/15/23.
//

import Foundation

struct ContentViewModel {
    var index = 0
    var transitionAnimation: CGFloat = 200.0
    let carousel = [
        Carousel(name: "money.bag", text: "O conhecimento começa pequeno", styleValue: 0),
        Carousel(name: "money.safe", text: "Vamos enteder \n  o que é valor", styleValue: 1)
    ]
}
