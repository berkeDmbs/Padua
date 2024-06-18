//
//  ContentView.swift
//  Padua
//
//  Created by Berke Demirbaş on 26.11.2023.
//

import SwiftUI
import CodeScanner
import SwiftData
import AVFoundation

struct ContentView: View {
    
    @Query var store: [Resto]
    @Environment(\.modelContext) var modelContext
    
    @StateObject var locationManager = LocationManager()
    
    @State private var searchQuery = ""
    @State private var addViewOn = false
    @State private var mapViewOn = false
    @State private var isShowingScanner = false
    @State var link: URL?
    @State var selectedSort = sortOption.allCases.first!
    
    var filteredItems: [Resto] {
        if searchQuery.isEmpty {
            return store.sort(on: selectedSort)
        }
        
        let filteredItems = store.compactMap {resto in
            let nameContainsQuery = resto.name.range(of: searchQuery, options: .caseInsensitive) != nil
        
            return nameContainsQuery ? resto : nil
        }
        
        return filteredItems.sort(on: selectedSort)
    }
    
    func deleteRestos(_ indexSet: IndexSet) {
        for index in indexSet {
            let resto = filteredItems[index]
            modelContext.delete(resto)
        }
    }
    
    func handleScan(result: Result<ScanResult, ScanError>) {
       isShowingScanner = false
        switch result {
        case .success(let result):
            let details = result.string
            link = URL(string: details)!
            var comps = URLComponents(url: link!, resolvingAgainstBaseURL: false)!
            comps.scheme = "https"
            link = comps.url
            print(link!)
            addViewOn = true
            
        case .failure(let error):
            print("Scanning failed: \(error.localizedDescription)")
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                if let code = link {
                    Spacer().frame(width: 0, height: 0)
                        .navigationDestination(isPresented: $addViewOn, destination: {AddView(locationManager: locationManager, linkStr: code)})
                        .hidden()
                }
                
                List{
                    ForEach(filteredItems, id: \.id) { resto in
                        VStack(alignment: .leading) {
                            NavigationLink {
                                DetailView(store: store, restoIns: resto)
                            } label: {
                                Text(resto.name)
                                    .font(.title3)
                                    .bold()
                            }
                            HStack {
                                Text("Price: ")
                                Spacer()
                                StarView(rating: .constant(resto.price), shape: "lira")
                                    .frame(width: 140)
                            }
                            HStack {
                                Text("Rating: ")
                                Spacer()
                                StarView(rating: .constant(resto.rating), shape: "star")
                            }
                        }
                    }
                    .onDelete(perform: deleteRestos)
                }
           
            }
            .onAppear(perform: {
                locationManager.checkLocationAuthorization()
            })
            .navigationTitle("Padua")
            .animation(.easeIn, value: filteredItems)
            .searchable(text: $searchQuery, prompt: "Search for a name")
            
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    Button(action: {
                       
                        mapViewOn.toggle()
                    }, label: {
                        Image(systemName: "map")
                    })
                    
                    Spacer()
                    
                    Button(action: {
                        isShowingScanner = true
                    }, label: {
                        Image(systemName: "plus")
                    })
                }
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Menu {
                        Picker("", selection: $selectedSort) {
                            ForEach(sortOption.allCases, id: \.rawValue) { option in
                                Label(option.rawValue.capitalized, systemImage: option.systemImage)
                                    .tag(option)
                            }
                        }
                        .labelsHidden()
                    } label: {
                        Image(systemName: "arrow.up.arrow.down.circle")
                    }
                }
            }
            .sheet(isPresented: $mapViewOn) {
                MapView(store: store, locationManager: locationManager)
            }
            .sheet(isPresented: $isShowingScanner, content: {
                CodeScannerView(codeTypes: [.qr], simulatedData: "hello",videoCaptureDevice: AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) , completion: handleScan)
            })
        }
    }
}

enum sortOption: String, CaseIterable {
    case name
    case price
    case rating
}

extension sortOption {
    var systemImage: String {
        switch self {
        case .name: "textformat.size.larger"
        case .price: "dollarsign"
        case .rating: "star"
        }
    }
}

private extension [Resto] {
    
    func sort(on option: sortOption) -> [Resto] {
        switch option {
        case .name:
            self.sorted(by: {$0.name < $1.name} )
        case .price:
            self.sorted(by: {$0.price < $1.price} )
        case .rating:
            self.sorted(by: {$0.rating < $1.rating} )
        }
    }
}

