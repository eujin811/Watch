//
//  ChargerAPI.swift
//  WatchEx Watch App
//
//  Created by YoujinMac on 2023/02/06.
//

import Foundation
import Combine

import Alamofire

protocol ChargerAPIProtocol {
//    func getStationList(lat: Float, lon: Float) -> Result<ChargerListModel, AFError>
    func getStationList(
        lat: Double,
        lon: Double,
        completion: @escaping (Result<ChargerListModel, AFError>) -> Void)

}

final class ChargerAPI: ChargerAPIProtocol {
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
