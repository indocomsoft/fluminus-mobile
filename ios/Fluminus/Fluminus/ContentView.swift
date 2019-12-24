//
//  ContentView.swift
//  Fluminus
//
//  Created by Julius on 24/12/19.
//  Copyright © 2019 Julius. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State var domain: Domain = .nusstu
    @State var username: String = ""
    @State var password: String = ""

    var body: some View {
        Form {
            Picker(selection: $domain, label: Text("Domain")) {
                ForEach(Domain.allCases) { domain in
                    Text(domain.rawValue).tag(domain)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            TextField("Username (e.g. e0012345)", text: $username)
            SecureField("Password", text: $password)
        }
        .navigationBarTitle(Text("Login"))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ContentView()
        }
    }
}
