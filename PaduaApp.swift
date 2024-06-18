//
//  PaduaApp.swift
//  Padua
//
//  Created by Berke Demirbaş on 26.11.2023.
//

import SwiftUI
import SwiftData

@main
struct PaduaApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Resto.self)
    }
}
