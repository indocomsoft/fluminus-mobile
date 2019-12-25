//
//  FluminusError.swift
//  Fluminus
//
//  Created by Julius on 25/12/19.
//  Copyright © 2019 Julius. All rights reserved.
//

import Alamofire
import Foundation
import KeychainAccess

enum FluminusError: Error {
    case unauthorized
    case unexpectedNil
    case wrongStatusCode(statusCode: Int)
    case parsing
    case afError(AFError)
    case strongReference
    case keychain(Status)
}

extension FluminusError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .unauthorized: return "Wrong username/password"
        case let .afError(error): return error.errorDescription
        case let .keychain(error): return error.description
        default: return "Other error, please submit a feedback quoting this error: \(self)"
        }
    }
}
