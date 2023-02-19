//
//  ChargerAPI.swift
//  WatchEx Watch App
//
//  Created by YoujinMac on 2023/02/06.
//

import Foundation
import Combine
import Then

import Alamofire

protocol ChargerAPIProtocol {
    func getStationList(
        lat: Double,
        lon: Double,
        completion: @escaping (Result<ChargerListModel, AFError>) -> Void)
    
    // basic
    func getStationList(lat: Double, lon: Double) -> AnyPublisher<ChargerListModel, Error>?
    // alamofire
    func getStationListAF(lat: Double, lon: Double) -> AnyPublisher<ChargerListModel?, Never>?

}

final class ChargerAPI: ChargerAPIProtocol {
    typealias HTTPParameters = [String: Any]
    
//    getStationListAF 애는 잘만 되는디 도대체 왜!
    func getStationList(lat: Double, lon: Double) -> AnyPublisher<ChargerListModel, Error>? {
//        guard let url = URL(string: "\(Constants.apiURL.dev)/test/test/station_list") else { return nil }
        guard let url = URL(string: "\(Constants.apiURL.dev)/test/test/station_list?lat=\(lat)&lon=\(lon)") else { return nil }
        
//        let reqParam: Parameters = [
//            "lat": "\(lat)",
//            "lon": "\(lon)"
//        ]
//
        var request = URLRequest (url: url)
        request.httpMethod = "GET"//HTTPMethod.get.rawValue
//        if let body = try? JSONSerialization.data(withJSONObject: reqParam, options: []) {
//            request.httpBody = body
//        }

        request.setValue("application/json", forHTTPHeaderField: "Accept")

        print("getStation \(request), url \(url)")

        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { item, response -> ChargerListModel in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode >= 200
                else {
                    throw URLError(.badServerResponse)
                }

                return try JSONDecoder().decode(ChargerListModel.self, from: item)
//                try JSONDecoder().decode(ChargerListModel.self, from: item)
            }
            .eraseToAnyPublisher()


    }
    
    // Alamofire 버전
    func getStationListAF(lat: Double, lon: Double) -> AnyPublisher<ChargerListModel?, Never>? {
        
        let reqParam: Parameters = [
            "lat": "\(lat)",
            "lon": "\(lon)"
        ]

        return Future<ChargerListModel?, Never> { promise in
            AF.request("https://dev.soft-berry.co.kr/test/test/station_list",
                       method: .get,
                       parameters: reqParam,
                       encoding: URLEncoding.default)
            .responseDecodable(of: ChargerListModel.self) { response in

                switch response.result {
                case .success(let result):
                    promise(.success(result))
                    print("성공 \(result)")

                case .failure(let error):
                    promise(.success(nil))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func getStationList(lat: Double, lon: Double, completion: @escaping (Result<ChargerListModel, AFError>) -> Void) {
        let reqParam: Parameters = [
            "lat": "\(lat)",
            "lon": "\(lon)"
        ]
        
        AF.request("https://dev.soft-berry.co.kr/test/test/station_list",
                   method: .get,
                   parameters: reqParam,
                   encoding: URLEncoding.default)
        .responseDecodable(of: ChargerListModel.self) { response in
            
            switch response.result {
            case .success(let result):
                completion(.success(result))
                print("성공 \(result)")
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}
