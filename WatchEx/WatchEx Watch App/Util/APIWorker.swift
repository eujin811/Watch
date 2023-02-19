//
//  APIWorker.swift
//  WatchEx Watch App
//
//  Created by YoujinMac on 2023/02/13.
//

import Foundation

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
    func request(
        url urlStr: String,
        method: HTTPMethod,
        parameters: HTTPParameters? = nil,
        headers: APIHeaders? = nil,
        completion: @escaping (Result<Data, WCError>) -> Void
    ) {
        guard let request = request(url: urlStr, method: method, parameters: parameters, headers: headers) else {
            print(WCError.dataDecode.message)
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error != nil else {
                completion(.failure(.dataTask))
                return
            }
            guard let _data = data else {
                completion(.failure(.unknownData))
                return
            }

            completion(.success(_data))
        }
        
        task.resume()
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
            
        print("request \(request) \(method.rawValue) \(parameters), \(headers)")
        return request
    }
    
}
