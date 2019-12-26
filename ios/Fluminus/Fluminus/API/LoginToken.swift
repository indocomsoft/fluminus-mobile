//
//  LoginToken.swift
//  Fluminus
//
//  Created by Julius on 25/12/19.
//  Copyright © 2019 Julius. All rights reserved.
//

import Alamofire
import Combine
import Foundation

struct LoginToken: Codable {
    let accessToken: String

    private enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
    }

    private struct ApiData<T: Codable>: Codable {
        let data: T
    }

    /// `path` will simply be appended to the base URL.
    func api<T: Codable>(path: String, of _: T.Type = T.self) -> AnyPublisher<T,
                                                                              FluminusError> {
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)",
            "Ocp-Apim-Subscription-Key": Constants.ocmApimSubscriptionKey,
            "Content-Type": "application/json",
        ]
        let url = Constants.apiBaseUrl.absoluteString + path
        return AFHelper.request(url, headers: headers)
            .flatMap { AFHelper.getResponseDecodable($0, of: ApiData<T>.self) }
            .map { $0.data }
            .eraseToAnyPublisher()
    }

    func getModules() -> AnyPublisher<[Module], FluminusError> {
        api(path: "/module", of: [Module].self).eraseToAnyPublisher()
    }
}
