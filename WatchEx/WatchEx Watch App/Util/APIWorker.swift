//
//  APIWorker.swift
//  WatchEx Watch App
//
//  Created by YoujinMac on 2023/02/13.
//

import Foundation
import Combine

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case patch = "PATCH"
    case delete = "DELETE"
}

struct APIHeaders {
    var headers = [HTTPHeader]()
    
    var dictionary: [String: String] {
        let namesAndValues = headers.map { ($0.name, $0.value) }

        return Dictionary(namesAndValues, uniquingKeysWith: { _, last in last })
    }
    
    struct HTTPHeader: Hashable {
        let name: String
        let value: String

        init(name: String, value: String) {
            self.name = name
            self.value = value
        }
    }
}

struct APIWorker {
    typealias HTTPParameters = [String: Any]
    
    func request<T: Decodable>(
        url urlStr: String,
        method: HTTPMethod,
        parameters: HTTPParameters? = nil,
        headers: APIHeaders? = nil
    ) -> AnyPublisher<T, APIError> where T:Decodable {
            guard let request = request(url: urlStr, method: method, parameters: parameters, headers: headers)
            else { return Fail(error: APIError.urlRequest)
                .eraseToAnyPublisher() }
        
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .receive(on: DispatchQueue.main)
            .mapError { _ in APIError.unexpectedResponse }
            .flatMap { data, response -> AnyPublisher<T, APIError> in
                guard let response = response as? HTTPURLResponse else {
                    return Fail(error: APIError.unexpectedResponse)
                        .eraseToAnyPublisher()
                }
                
                switch response.statusCode {
                case 200...299:
                    return Just(data)
                        .decode(type: T.self, decoder: JSONDecoder())
                        .mapError { error in
                            print("Error Check : \(error)")
                            return .unexpectedResponse
                        }
                        .eraseToAnyPublisher()
                default:
                    return Fail(error: APIError.httpCode(response.statusCode))
                        .eraseToAnyPublisher()
                }
                
            }
            .eraseToAnyPublisher()
    }
    
    private func request(
        url urlStr: String,
        method: HTTPMethod,
        parameters: HTTPParameters?,
        headers: APIHeaders?
    ) -> URLRequest? {
        guard let url = URL(string: urlStr) else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        if let _parameters = parameters, let body = try? JSONSerialization.data(withJSONObject: _parameters, options: []) {
            request.httpBody = body
        }
        
        if let _headers = headers {
            request.allHTTPHeaderFields = _headers.dictionary
        }
            
        return request
    }
    
}
