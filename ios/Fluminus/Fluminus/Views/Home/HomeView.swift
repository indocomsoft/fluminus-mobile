//
//  HomeView.swift
//  Fluminus
//
//  Created by Julius on 25/12/19.
//  Copyright © 2019 Julius. All rights reserved.
//

import Combine
import SwiftUI

struct HomeView: View {
    @ObservedObject var account: Account = .shared

    @State var cancellables = Set<AnyCancellable>()

    var body: some View {
        NavigationView {
            Text("Logged in")
                .navigationBarTitle(Text("Home"))
                .navigationBarItems(trailing: HStack {
                    Button(action: self.logout) {
                        Text("Log out")
                    }
                })
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    private func logout() {
        account.delete()
            .sink(receiveCompletion: { _ in }) {}
            .store(in: &cancellables)
    }
}

#if DEBUG
    struct HomeView_Previews: PreviewProvider {
        static var previews: some View {
            HomeView()
        }
    }
#endif
