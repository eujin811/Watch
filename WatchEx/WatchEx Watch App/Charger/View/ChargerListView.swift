//
//  ChargerListView.swift
//  WatchEx Watch App
//
//  Created by YoujinMac on 2023/02/06.
//

import SwiftUI

final class ChargerListStore: ObservableObject {
    @Published var chargerList = [ChargerListModel.ChargerListItem] ()
    @Published var myLocation: Location
    @Published var showItem: ChargerListModel.ChargerListItem!
    private let restAPI = ChargerAPI()
    
    init(location: Location) {
        self.myLocation = location
        
        let data = restAPI.getStationList(lat: location.lat, lon: location.lon) { result in
            switch result {
            case .success(let chargerListModel):
                guard chargerListModel.code == 1000 else {
                    print("sever error) code: \(chargerListModel.code)")
                    return
                }
                
                self.chargerList = chargerListModel.itemList
                self.showItem = chargerListModel.itemList.first
                
            case .failure(let error):
                print("에러발생 \(error)")
            }
        }
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
                    Image(systemName: "photo.circle")
                        .frame(width: 12, height: 12)
                    Text(item.operation)    // fontsize 8
                        .font(.system(size: 8, weight: .semibold))
                    Spacer()
                    Text("xx km")
                }
                .frame(height: 14)
                .padding(.top, 10)
                
                Text(item.stationName)  // fontSize 12
                    .font(.system(size: 12, weight: .bold))
                    .frame(height: 16)
                
                HStack {
                    Text("급속 어쩌고~ 완속 어쩌고")
                        .font(.system(size: 10, weight: .semibold))
                }
                
                ScrollView(.horizontal) {
                    LazyHStack {
                        CellView()
                            .frame(width: 91, height: 35)
                            .background(.gray)
                        
                        CellView()
                            .frame(width: 91, height: 35)
                            .background(.gray)
                        
                        CellView()
                            .frame(width: 91, height: 35)
                            .background(.gray)
                        
                    }
                }
            }
            .frame(height: 119)
            .cornerRadius(3)
            
        }
        .listStyle(CarouselListStyle())
        .padding(.leading, 8)
        .padding(.trailing, 8)
    }
}


fileprivate struct CellView: View {
    
    var body: some View {
        VStack {
            Text("충전 여부")
                .font(.system(size: 8, weight: .semibold))
            
            Text("충전기 정보")
                .font(.system(size: 6))
        }
        .cornerRadius(2)
    }
}

struct ChargerListView_Previews: PreviewProvider {
    static var previews: some View {
        ChargerListView()
            .environmentObject(ChargerListStore(location: .init(lat: 37.5666101, lon: 126.97838810)))
    }
}
