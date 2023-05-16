//
//  Pocket_MoneyApp.swift
//  Pocket Money
//
//  Created by Dyan on 5/3/23.
//

import SwiftUI

    @main
struct Pocket_MoneyApp: App {
    @StateObject var viewModel = SignInViewModel()
    @StateObject var registeredChildrenViewModel = ListOfChildrenViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
                .environmentObject(registeredChildrenViewModel)
        }
    }
}
