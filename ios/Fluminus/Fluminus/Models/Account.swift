//
//  Account.swift
//  Fluminus
//
//  Created by Julius on 25/12/19.
//  Copyright © 2019 Julius. All rights reserved.
//

import Combine
import Foundation
import KeychainAccess

class Account: ObservableObject {
    static let shared = Account()

    private let userDefaultsKey = "username"
    private let keychain = Keychain(service: "vafs")

    private var cancellables = Set<AnyCancellable>()

    @Published var isLoggedIn: Bool = false
    @Published var accessToken: LoginToken?

    private var credential: (String, String)? {
        guard let username = UserDefaults.standard.string(forKey: userDefaultsKey),
            let password = keychain[string: username]
        else {
            return nil
        }
        return (username, password)
    }

    private init() {
        isLoggedIn = credential != nil
        updateAccessToken()
    }

    func updateAccessToken() {
        guard let (username, password) = credential else {
            return
        }
        Auth.login(username: username, password: password)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else {
                    return
                }
                switch completion {
                case .failure(.unauthorized):
                    self.delete()
                        .sink(receiveCompletion: { _ in }, receiveValue: {})
                        .store(in: &self.cancellables)
                default: break
                }
            }) { [weak self] in self?.accessToken = $0 }
            .store(in: &cancellables)
    }

    func save(username: String, password: String) -> AnyPublisher<Void, FluminusError> {
        Auth.login(username: username, password: password)
            .receive(on: DispatchQueue.main)
            .flatMap { [weak self] _ -> AnyPublisher<Void, FluminusError> in
                guard let self = self else {
                    return Fail(error: FluminusError.strongReference).eraseToAnyPublisher()
                }
                self.keychain[username] = password
                UserDefaults.standard.set(username, forKey: self.userDefaultsKey)
                self.isLoggedIn = true
                return Just(())
                    .setFailureType(to: FluminusError.self)
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }

    func delete() -> AnyPublisher<Void, FluminusError> {
        Deferred {
            Future<Void, FluminusError> { [weak self] promise in
                guard let self = self else {
                    return promise(.failure(FluminusError.strongReference))
                }
                guard let username = self.credential?.0 else {
                    return promise(.success(()))
                }
                self.keychain[username] = nil
                UserDefaults.standard.removeObject(forKey: self.userDefaultsKey)
                self.isLoggedIn = false
                promise(.success(()))
            }
        }
        .subscribe(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
}
