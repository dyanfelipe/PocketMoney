//
//  TextFieldBorderIcon.swift
//  Pocket Money
//
//  Created by Dyan on 5/15/23.
//

import Foundation
import SwiftUI

struct TextFieldBorderIcon: ViewModifier { // .modifier(TextFieldBorderIcon())
    func body(content: Content) -> some View {
        content
        .padding()
        .overlay {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .stroke(Color(UIColor.systemGray4), lineWidth: 2)
        }
        .padding([.horizontal])
    }
}

extension View {
    func textFieldBorderIcon() -> some View {
        modifier(TextFieldBorderIcon())
    }
}
