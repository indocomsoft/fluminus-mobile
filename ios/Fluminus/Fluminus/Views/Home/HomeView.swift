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

    @State var modules: [Module] = []
    @State var isLoading = true

    var content: some View {
        NavigationView {
            VStack {
                Text("Logged in")

                List(modules) { module in
                    NavigationLink(destination: AnnouncementView(module: module)) {
                        Text("\(module.code) \(module.name)")
                    }
                }
            }
            .navigationBarTitle(Text("Home"))
            .navigationBarItems(trailing: HStack {
                Button(action: self.logout) {
                    Text("Log out")
                }
            })
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            self.hookToModules()
        }
    }

    @ViewBuilder
    var body: some View {
        if isLoading {
            content.overlay(ActivityIndicator(isShown: $isLoading))
        } else {
            content
        }
    }

    private func hookToModules() {
        account.$accessToken
            .compactMap { $0 }
            .sink(receiveCompletion: { _ in }) { loginToken in
                loginToken
                    .getModules()
                    .catch { _ in Just([]) }
                    .sink { modules in
                        self.isLoading = false
                        self.modules = modules
                    }
                    .store(in: &self.cancellables)
            }
            .store(in: &cancellables)
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
