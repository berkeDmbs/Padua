//
//  AddView.swift
//  Padua
//
//  Created by Berke Demirbaş on 26.11.2023.
//

import SwiftUI

struct AddView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    @StateObject var locationManager: LocationManager
    
    @State var linkStr : URL
    @State private var name = ""
    @State private var price = 1
    @State private var rating = 1
    @State private var desc = "Add a note or a description"
    
    var body: some View {
        VStack {
            Form {
                TextField(text: $name) {
                    Text("Name")
                }
                Text("Link: \(linkStr)")
            
                Stepper("Price: \(price)", value: $price, in: 1...5)
                Stepper("Rating: \(rating)", value: $rating, in: 1...5)
                TextEditor(text: $desc)
                
                
                Button(action: {
                    if(name != "") {
                        modelContext.insert((Resto(link: linkStr, name: name, price: price, rating: rating, lat: locationManager.lastKnownLocation!.latitude, lon: locationManager.lastKnownLocation!.longitude, desc: desc)))
                    }
                    print(linkStr)
                    name = ""
                    price = 0
                    rating = 0
                    dismiss()
                }, label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 25)
                        Text("Done").foregroundStyle(.white)
                    }
                })
                .padding(.vertical)
            }
        }
    }
}

//#Preview {
  //  AddView(store: Store(), linkStr: "AAA")
//}
