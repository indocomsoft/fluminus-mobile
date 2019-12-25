//
//  ContentView.swift
//  Fluminus
//
//  Created by Julius on 24/12/19.
//  Copyright © 2019 Julius. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var account: Account = .shared

    @ViewBuilder
    var body: some View {
        if account.isLoggedIn {
            HomeView()
        } else {
            LoginView()
        }
    }
}

#if DEBUG
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
#endif
