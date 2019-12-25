//
//  LoginView.swift
//  Fluminus
//
//  Created by Julius on 25/12/19.
//  Copyright © 2019 Julius. All rights reserved.
//

import Combine
import SwiftUI

struct LoginView: View {
    @ObservedObject var account: Account = .shared

    @State var isLoading = false

    @State var domain: Domain = .nusstu
    @State var username: String = ""
    @State var password: String = ""

    @State var alertTitle: String = ""
    @State var alertMessage: String = ""
    @State var showAlert: Bool = false

    @State var cancellables = Set<AnyCancellable>()

    var form: some View {
        NavigationView {
            Form {
                Section(header: Text("Domain")) {
                    Picker(selection: $domain, label: Text("Domain")) {
                        ForEach(Domain.allCases) { domain in
                            Text(domain.rawValue).tag(domain)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }

                Section(header: Text("Credentials")) {
                    TextField("Username (e.g. e0012345)", text: $username)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                    SecureField("Password", text: $password)
                }

                Section {
                    Button(action: self.login) {
                        Text("Login")
                    }
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text(alertTitle), message: Text(alertMessage))
                    }
                    .disabled(isLoading || username.isEmpty || password.isEmpty)
                }
            }
            .navigationBarTitle(Text("Login"))
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    @ViewBuilder
    var body: some View {
        if isLoading {
            form.disabled(true).overlay(ActivityIndicator(isShown: $isLoading))
        } else {
            form
        }
    }

    private func login() {
        isLoading = true
        account.save(username: "\(domain)\\\(username)", password: password)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                self.isLoading = false
                switch completion {
                case .finished: break
                case let .failure(error):
                    self.showAlert = true
                    self.alertTitle = "Error"
                    self.alertMessage = error.localizedDescription
                }
            }) {}
            .store(in: &cancellables)
    }
}

#if DEBUG
    struct LoginView_Previews: PreviewProvider {
        static var previews: some View {
            LoginView()
        }
    }
#endif
