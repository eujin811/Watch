//
//  MainView.swift
//  WatchEx Watch App
//
//  Created by YoujinMac on 2023/02/06.
//

import SwiftUI

import CoreLocation
final class MainStore: ObservableObject {
    @Published var myLocation = Location(lat: 0, lon: 0)
    @Published var isOnLocation: Bool
    
    private let locationManager = CLLocationManager()
    
    init() {
        
        
        self.isOnLocation = CLLocationManager.locationServicesEnabled()
        
        requestLocation()
    }
    
    func requestLocation() {
        guard CLLocationManager.locationServicesEnabled() else { return }
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        print("위치 \(locationManager.location?.coordinate)")

        guard let cool = locationManager.location?.coordinate else { return }
        self.myLocation = .init(lat: cool.latitude, lon: cool.longitude)
    }
}

struct MainView: View {
    @EnvironmentObject var store: MainStore
    @State private var showChargerListView = false
    
    var body: some View {
        VStack {
            Button("내근처 10개 보기!") {
                showChargerListView.toggle()
            }
            .sheet(isPresented: $showChargerListView) {
                ChargerListView()
                    .environmentObject(ChargerListStore(location: .init(lat: 37.5666101, lon: 126.97838810)))
            }
            
//            Text("내 좌표 \(store.myLocation.lon)")
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(MainStore())
    }
}
