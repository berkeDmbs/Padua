//
//  Resto.swift
//  Padua
//
//  Created by Berke Demirbaş on 26.11.2023.
//

import Foundation
import SwiftData

@Model
class Resto {
    let id: UUID
    var link: URL
    var name: String
    var price: Int
    var rating: Int
    var lat: Double
    var lon: Double
    var desc: String
    
    init(link: URL, name: String, price: Int,  rating: Int, lat: Double, lon: Double, desc: String) {
        id = UUID()
        self.link = link
        self.name = name
        self.price = price
        self.rating = rating
        self.lat = lat
        self.lon = lon
        self.desc = desc
    }
}
