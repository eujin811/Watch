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
    func getStationList(lat: Double, lon: Double) -> AnyPublisher<ChargerListModel, APIError>?
    // alamofire
    func getStationListAF(lat: Double, lon: Double) -> AnyPublisher<ChargerListModel?, Never>?

}

final class ChargerAPI: ChargerAPIProtocol {
    typealias HTTPParameters = [String: Any]
    
    func getStationList(lat: Double, lon: Double) -> AnyPublisher<ChargerListModel, APIError>? {
        
        return APIWorker().request(
            url: "https://dev.soft-berry.co.kr/test/test/station_list?lat=\(lat)&lon=\(lon)",
            method: .get)
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
