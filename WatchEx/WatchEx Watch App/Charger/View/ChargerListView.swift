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
            Button("item \(item.stationName)") {
                showChargerDetailView.toggle()
                store.showItem = item
            }
            .sheet(isPresented: $showChargerDetailView) {
                ChargerDetailView()
                    .environmentObject(ChargerDetailStore(myLocation: store.myLocation, item: store.showItem))
            }
            
        }
        .listStyle(CarouselListStyle())
    }
}

struct ChargerListView_Previews: PreviewProvider {
    static var previews: some View {
        ChargerListView()
            .environmentObject(ChargerListStore(location: .init(lat: 37.5666101, lon: 126.97838810)))
    }
}

