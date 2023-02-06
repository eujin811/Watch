//
//  ChargerDetailView.swift
//  WatchEx Watch App
//
//  Created by YoujinMac on 2023/02/06.
//

import SwiftUI
import MapKit

final class ChargerDetailStore: ObservableObject {
    @Published var myLocation: Location
    @Published var chargerItem: ChargerListModel.ChargerListItem
    @Published var region: MKCoordinateRegion
    
    init(myLocation: Location, item: ChargerListModel.ChargerListItem) {
        self.myLocation = myLocation
        self.chargerItem = item
        let lat = Double(item.lat) ?? 0
        let lon = Double(item.lon) ?? 0
        self.region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: lat, longitude: lon),
            span: MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002))
    }
    
}
        

struct ChargerDetailView: View {
    @EnvironmentObject var store: ChargerDetailStore
    
    var body: some View {
        VStack {
            Map(coordinateRegion: $store.region)
            
            Text("\(store.chargerItem.stationName) 충전소 위치 \(store.chargerItem.lat), \(store.chargerItem.lon)")
//            Text("내 위치 \(store.myLocation.lat), \(store.myLocation.lon)")
            
        }
    }
}

struct ChargerDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ChargerDetailView()
//            .environmentObject(ChargerDetailStore(
//                myLocation: .init(lat: 37.5666101, lon: 126.97838810),
//                item: <#T##ChargerListModel.ChargerListItem#>))
    }
}
