//
//  ChargerListView.swift
//  WatchEx Watch App
//
//  Created by YoujinMac on 2023/02/06.
//

import SwiftUI

import Combine
final class ChargerListStore: ObservableObject {
    @Published var chargerList = [ChargerListModel.ChargerListItem] ()
    @Published var myLocation: Location
    @Published var showItem: ChargerListModel.ChargerListItem!
    private let restAPI = ChargerAPI()
    
    var cancellables = Set<AnyCancellable>()
    
    init(location: Location) {
        self.myLocation = location
        
        let requestStationList = restAPI.getStationList(lat: location.lat, lon: location.lon)
        
        requestStationList?.sink(
            receiveCompletion: { completion in
                if case .failure(let error) = completion {
                  print("Retrieving data failed with error: \(error)")
                }
            },
            receiveValue: { [weak self] data in
                guard data.code == 1000 else {
                    print("failError: sever code \(data.code)")
                    return
                }
                
                self?.chargerList = data.itemList
                self?.showItem = data.itemList.first
                
            })
        .store(in: &cancellables)
    
    }
    
}

struct ChargerListView: View {
    @EnvironmentObject var store: ChargerListStore
    @State private var multiSelection = Set<UUID>()
    
    @State private var showChargerDetailView = false
    
    var body: some View {
        List(store.chargerList, id: \.id) { item in
            VStack {
                HStack {
                    Text(item.operation)    // fontsize 8
                        .font(.system(size: 12, weight: .semibold))
                    Spacer()
                    Text("xx km")
                        .font(.system(size: 12, weight: .semibold))
                    Image(systemName: "mappin")
                                           .frame(width: 12, height: 12)
                }
                .padding(.top, 10)
                .padding(.leading, 10)
                .padding(.trailing, 8)
                                
                Text(item.stationName)  // fontSize 12
                    .font(.system(size: 16, weight: .bold))
                    .padding(.top, 8)
                    .padding(.leading, 10)
                    
                Divider()
                    .padding(.top, 8)
                    .padding(.leading, 10)
                    .padding(.trailing, 10)
                // 대충 line
                
                VStack {
                    ChargerItemInfoView(type: "급속", count: "1/1", chargerDetail: "단독.100kw")
                    ChargerItemInfoView(type: "완속", count: "1/1", chargerDetail: "양팔.7kw")
                }
                .padding(.bottom, 12)
            }
            .frame(height: 117)
            .cornerRadius(2)
            
        }
        .listStyle(CarouselListStyle())
        .padding(.leading, 8)
        .padding(.trailing, 8)
    }
}

fileprivate struct ChargerItemInfoView: View {
    @State var type: String
    @State var count: String
    @State var chargerDetail: String
    
    var body: some View {
        HStack {
            Image(systemName: "moon.fill")
                .frame(width: 12, height: 12)
                .foregroundColor(.green)
                .padding(.leading, 10)

            Text(type)
                .font(.system(size: 12, weight: .bold))
            
            Text(count)
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.green)
                .padding(.leading, 5)

            Spacer()
            
            Text(chargerDetail)
                .font(.system(size: 12, weight: .thin))
                .padding(.leading, 11)

        }
    }
}

struct ChargerListView_Previews: PreviewProvider {
    static var previews: some View {
        ChargerListView()
            .environmentObject(ChargerListStore(location: .init(lat: 37.5666101, lon: 126.97838810)))
    }
}

