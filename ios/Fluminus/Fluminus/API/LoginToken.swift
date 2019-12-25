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

    func api<T: Decodable>(path: String, of type: T.Type = T.self) -> AnyPublisher<T,
                                                                                   FluminusError> {
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)",
            "Ocp-Apim-Subscription-Key": Constants.ocmApimSubscriptionKey,
            "Content-Type": "application/json",
        ]
        let url = Constants.apiBaseUrl.appendingPathComponent(path)
        return AFHelper.request(url, headers: headers)
            .flatMap { AFHelper.getResponseDecodable($0, of: type) }
            .eraseToAnyPublisher()
    }

    func getModules() -> AnyPublisher<[Module], FluminusError> {
        api(path: "/module", of: ApiData<[Module]>.self)
            .map { $0.data }
            .eraseToAnyPublisher()
    }
}
