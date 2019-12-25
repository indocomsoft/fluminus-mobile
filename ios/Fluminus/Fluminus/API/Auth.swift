//
//  Auth.swift
//  Fluminus
//
//  Created by Julius on 24/12/19.
//  Copyright © 2019 Julius. All rights reserved.
//

import Alamofire
import Combine
import Foundation

enum Auth {
    private struct LoginToken: Codable {
        let accessToken: String

        private enum CodingKeys: String, CodingKey {
            case accessToken = "access_token"
        }
    }

    /// Obtains an access token
    static func login(username: String, password: String) -> AnyPublisher<String, FluminusError> {
        let credential: Parameters = ["UserName": username, "Password": password, "AuthMethod": "FormsAuthentication"]
        return AFHelper.request(Constants.vafsURL, method: .post, parameters: credential)
            .flatMap { AFHelper.getRedirectLocation($0) }
            .mapError { error in
                switch error {
                case .wrongStatusCode(statusCode: 200): return .unauthorized
                default: return error
                }
            }
            .flatMap { AFHelper.request($0) }
            .flatMap { AFHelper.getRedirectLocation($0) }
            .flatMap { location -> AnyPublisher<DataRequest, FluminusError> in
                guard let urlComponents = URLComponents(string: location),
                    let queryItems = urlComponents.queryItems,
                    let code = queryItems.first(where: { $0.name == "code" })?.value else {
                    return Fail(error: FluminusError.parsing).eraseToAnyPublisher()
                }
                let adfsBody: Parameters = [
                    "grant_type": "authorization_code",
                    "client_id": Constants.clientId,
                    "resource": Constants.resource,
                    "redirect_uri": Constants.redirect,
                    "code": code,
                ]
                let headers = HTTPHeaders(["Ocp-Apim-Subscription-Key": Constants.ocmApimSubscriptionKey])
                return AFHelper.request(Constants.apiBaseUrl.appendingPathComponent("/login/adfstoken"),
                                        method: .post, parameters: adfsBody, headers: headers)
            }
            .flatMap { AFHelper.getResponseDecodable($0, of: LoginToken.self) }
            .map { $0.accessToken }
            .eraseToAnyPublisher()
    }
}
