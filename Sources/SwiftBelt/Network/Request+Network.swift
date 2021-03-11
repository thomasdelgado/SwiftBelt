//
//  Request+Network.swift
//  
//
//  Created by Thomas Delgado on 24/02/21.
//

import Foundation
import Combine

/*
 A class for network requests using Combine and type-safe networking
 based and adapted on https://swiftwithmajid.com/2021/02/10/building-type-safe-networking-in-swift/
 */
public extension URLSession {
    enum Error: Swift.Error {
        case networking(URLError)
        case decoding(Swift.Error)
    }

    func publisher(for request: Request<Data>) -> AnyPublisher<Data, Swift.Error> {
        dataTaskPublisher(for: request.urlRequest)
            .mapError(Error.networking)
            .map(\.data)
            .eraseToAnyPublisher()
    }

    func publisher<Value: Decodable>(
        for request: Request<Value>,
        using decoder: JSONDecoder = .init()
    ) -> AnyPublisher<Value, Swift.Error> {
        dataTaskPublisher(for: request.urlRequest)            
            .mapError(Error.networking)
            .map(\.data)
            .decode(type: Value.self, decoder: decoder)
            .mapError(Error.decoding)
            .eraseToAnyPublisher()
    }
}

public struct Request<Response> {
    let url: URL
    let method: HttpMethod
    var headers: [String: String] = [:]

    public init(url: URL, method: HttpMethod, headers: [String: String] = [:]) {
        self.url = url
        self.method = method
        self.headers = headers
    }
}

public extension Request {
    var urlRequest: URLRequest {
        var request = URLRequest(url: url)

        switch method {
        case .post(let parameters), .put(let parameters):
            request.httpBody = encode(parameters)
        case let .get(queryItems):
            var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
            components?.queryItems = queryItems
            guard let url = components?.url else {
                preconditionFailure("Couldn't create a url from components...")
            }
            request = URLRequest(url: url)
        default:
            break
        }

        request.allHTTPHeaderFields = headers
        request.httpMethod = method.name
        return request
    }

    private func encode(_ parameters: Parameters?) -> Data? {
        if let parameters = parameters {
            do {
                return try JSONSerialization.data(withJSONObject: parameters, options: [])
            } catch let error {
                debugPrint(error)
            }
        }
        return nil
    }
}

public typealias Parameters = [String: Any]

public enum HttpMethod {
    case get([URLQueryItem])
    case put(Parameters?)
    case post(Parameters?)
    case delete
    case head

    var name: String {
        switch self {
        case .get: return "GET"
        case .put: return "PUT"
        case .post: return "POST"
        case .delete: return "DELETE"
        case .head: return "HEAD"
        }
    }
}
