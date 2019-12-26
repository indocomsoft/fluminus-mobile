//
//  AFHelper.swift
//  Fluminus
//
//  Created by Julius on 25/12/19.
//  Copyright © 2019 Julius. All rights reserved.
//

import Alamofire
import Combine
import Foundation

enum AFHelper {
    private static let jsonDecoder: JSONDecoder = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(formatter)
        return decoder
    }()

    private class NoRedirectSessionDelegate: SessionDelegate {
        override func urlSession(_: URLSession, task _: URLSessionTask,
                                 willPerformHTTPRedirection _: HTTPURLResponse,
                                 newRequest _: URLRequest,
                                 completionHandler: @escaping (URLRequest?) -> Void) {
            completionHandler(nil)
        }
    }

    private static let session = Alamofire.Session(configuration: URLSessionConfiguration.default,
                                                   delegate: NoRedirectSessionDelegate())
    private static let scheduler = DispatchQueue.global(qos: .userInitiated)

    static func request(_ convertible: URLConvertible,
                        method: HTTPMethod = .get,
                        parameters: Parameters? = nil,
                        encoding: ParameterEncoding = URLEncoding.default,
                        headers: HTTPHeaders? = nil,
                        interceptor: RequestInterceptor? = nil) -> AnyPublisher<DataRequest,
                                                                                FluminusError> {
        Deferred {
            Just(session.request(convertible, method: method, parameters: parameters,
                                 encoding: encoding, headers: headers, interceptor: interceptor)
            )
            .setFailureType(to: FluminusError.self)
            .subscribe(on: scheduler)
        }
        .eraseToAnyPublisher()
    }

    static func getRedirectLocation(_ request: DataRequest) -> AnyPublisher<String,
                                                                            FluminusError> {
        Deferred {
            Future<String, FluminusError> { promise in
                request.response(queue: scheduler) { dataResponse in
                    guard let response = dataResponse.response else {
                        if let error = dataResponse.error {
                            return promise(.failure(.afError(error)))
                        }
                        return promise(.failure(.unexpectedNil))
                    }
                    guard response.statusCode == 302 else {
                        return promise(.failure(.wrongStatusCode(statusCode: response.statusCode)))
                    }
                    guard let location = response.value(forHTTPHeaderField: "location") else {
                        return promise(.failure(.unexpectedNil))
                    }
                    return promise(.success(location))
                }
            }
            .subscribe(on: scheduler)
        }
        .eraseToAnyPublisher()
    }

    static func getResponseDecodable<T: Decodable>(_ request: DataRequest, of _: T.Type = T.self,
                                                   decoder: DataDecoder = jsonDecoder)
        -> AnyPublisher<T, FluminusError> {
        Deferred {
            Future<T, FluminusError> { promise in
                request.responseDecodable(of: T.self, queue: scheduler, decoder: decoder) { dataResponse in
                    promise(dataResponse.result.mapError { FluminusError.afError($0) })
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
