//
//  Constants.swift
//  Fluminus
//
//  Created by Julius on 24/12/19.
//  Copyright © 2019 Julius. All rights reserved.
//

import Foundation

enum Constants {
    static let apiBaseUrl = URL(string: "https://luminus.nus.edu.sg/v2/api")!
    static let ocmApimSubscriptionKey = "6963c200ca9440de8fa1eede730d8f7e"

    static let clientId = "E10493A3B1024F14BDC7D0D8B9F649E9-234390"
    static let resource = "sg_edu_nus_oauth"
    static let redirect = "https://luminus.nus.edu.sg/auth/callback"

    private static let vafsBaseUrl = URL(string: "https://vafs.nus.edu.sg/adfs/oauth2/authorize")!
    static let vafsURL: URL = {
        var urlComponents = URLComponents(url: vafsBaseUrl, resolvingAgainstBaseURL: true)!
        urlComponents
            .queryItems = [URLQueryItem(name: "response_type", value: "code"),
                           URLQueryItem(name: "client_id", value: clientId),
                           URLQueryItem(name: "redirect_uri", value: redirect),
                           URLQueryItem(name: "resource", value: resource)]
        return urlComponents.url!
    }()

    static let redirectUrl = URL(string: "https://luminus.nus.edu.sg/auth/callback")!
}
