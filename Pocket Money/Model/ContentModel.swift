//
//  ContentViewModel.swift
//  Pocket Money
//
//  Created by Dyan on 5/15/23.
//

import Foundation

struct Carousel: Identifiable {
    let name: String
    let text: String
    let styleValue: Int
    var id: String { name }
}
