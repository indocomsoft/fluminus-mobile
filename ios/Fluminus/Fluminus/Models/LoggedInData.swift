//
//  LoggedInData.swift
//  Fluminus
//
//  Created by Julius on 25/12/19.
//  Copyright © 2019 Julius. All rights reserved.
//

import Combine
import Foundation

class LoggedInData: ObservableObject {
    static let shared = LoggedInData()

    @Published var modules: [Module] = []

    private var cancellables = Set<AnyCancellable>()

    init() {
        Account.shared.$accessToken
            .sink(receiveCompletion: { _ in }) { [weak self] maybeLoginToken in
                guard let self = self, let loginToken = maybeLoginToken else {
                    return
                }
                loginToken.getModules()
                    .receive(on: DispatchQueue.main)
                    .sink(receiveCompletion: { _ in }) { self.modules = $0 }
                    .store(in: &self.cancellables)
            }
            .store(in: &cancellables)
    }
}
