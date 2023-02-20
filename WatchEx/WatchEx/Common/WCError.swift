//
//  WCError.swift
//  WatchEx
//
//  Created by YoujinMac on 2023/02/13.
//

import Foundation

enum APIError: Error {
    case unexpectedResponse
    case httpCode(Int)
    case invalidURL
    case urlRequest

    var message: String {
        switch self {
        case .unexpectedResponse:
            return "Response Error"
            
        case .httpCode(let code):
            return "http Code Error: \(code)"
            
        case .invalidURL:
            return "invalid url Error"
            
        case .urlRequest:
            return "urlRequest"
        }
    }
}

enum WCError: Error {
    case unknownData
    case unknownType
    case failRespose
    case dataTask
    case dataDecode
    case decode
    
    var message: String {
        switch self {
        case .unknownData:
            return "데이터를 미일치"
            
        case .unknownType:
            return "타입 미일치"
            
        case .failRespose:
            return "reponse 실패"
            
        case .dataTask:
            return "task 실패"
            
        case .dataDecode:
            return "데이터 decode 실패"
            
        case .decode:
            return "decode error"
        }
    }
}
