//
//  ChargerListModel.swift
//  WatchEx Watch App
//
//  Created by YoujinMac on 2023/02/06.
//

import Foundation

struct ChargerListModel: Codable {
    let code: Int
    let itemList: [ChargerListItem]
    
    enum CodingKeys: String, CodingKey {
        case code
        case itemList = "list"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.code = try container.decode(Int.self, forKey: .code)
        self.itemList = (try? container.decode([ChargerListItem].self, forKey: .itemList)) ?? [ChargerListItem]()
        
    }
    
    struct ChargerListItem: Codable {
        let id: String
        let stationName: String
        let operation: String
        let lat: String
        let lon: String
        let cl: [Cl]      // carload
        let st: String
        
        enum CodingKeys: String, CodingKey {
            case id, lat, lon, cl, st
            case stationName = "snm"
            case operation = "op"
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            self.id = try container.decode(String.self, forKey: .id)
            self.stationName = (try? container.decode(String.self, forKey: .stationName)) ?? String()
            self.operation = (try? container.decode(String.self, forKey: .operation)) ?? String()
            self.lat = (try? container.decode(String.self, forKey: .lat)) ?? String()
            self.lon = (try? container.decode(String.self, forKey: .lon)) ?? String()
            self.cl = (try? container.decode([Cl].self, forKey: .cl)) ?? [Cl]()
            self.st = (try? container.decode(String.self, forKey: .st)) ?? String()
        }
    }
    
    struct Cl: Codable {
        let cst: String
        let cid: String
        let p: String
        
        enum CodingKeys: String, CodingKey {
            case cst, cid, p
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            self.cst = (try? container.decode(String.self, forKey: .cst)) ?? String()
            self.cid = (try? container.decode(String.self, forKey: .cid)) ?? String()
            self.p = (try? container.decode(String.self, forKey: .p)) ?? String()
        }
    }
}
