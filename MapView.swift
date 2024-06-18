//
//  MapView.swift
//  Padua
//
//  Created by Berke Demirbaş on 29.01.2024.
//

import SwiftUI
import MapKit
import CoreLocation
import SwiftData
    
struct MapView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    var store: [Resto]
    
    @State var isDetailOn = false
    @State var restoIns: Resto?
    @StateObject var locationManager: LocationManager
    @State private var initialPosition: MapCameraPosition = .userLocation(
           fallback: .camera(
            MapCamera(centerCoordinate: CLLocationCoordinate2D(latitude: 40.730610, longitude: -73.935242), distance: 10000)
           )
       )
    
    var body: some View {
        NavigationStack {
            VStack{
                Map {
                    ForEach(store) { location in
                        Annotation(location.name, coordinate: CLLocationCoordinate2D(latitude: location.lat, longitude: location.lon)) {
                            Image(systemName: "star.circle")
                                .resizable()
                                .foregroundStyle(
                                    location.price >= 4 ? .red : .green
                                )
                                .frame(width: 44, height: 44)
                                .background(.white)
                                .clipShape(.circle)
                                .onTapGesture {
                                    restoIns = location
                                }
                        }
                    }
                }
            }
            .onChange(of: restoIns) {
                isDetailOn.toggle()
            }
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button(action: {dismiss()}, label: {
                        Text("Done")
                    })
                }
            }
            .sheet(isPresented: $isDetailOn) {
                DetailView(store: store, restoIns: restoIns!)
                    
            }
        }
    }
}
