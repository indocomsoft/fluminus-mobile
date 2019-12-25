//
//  FluminusError.swift
//  Fluminus
//
//  Created by Julius on 25/12/19.
//  Copyright © 2019 Julius. All rights reserved.
//

import Alamofire
import Foundation

enum FluminusError: Error {
    case unauthorized
    case unexpectedNil
    case wrongStatusCode(statusCode: Int)
    case parsing
    case afError(AFError)
}
