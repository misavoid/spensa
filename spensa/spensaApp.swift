//
//  spensaApp.swift
//  spensa
//
//  Created by Misa Nthrop on 10.05.25.
//

import SwiftUI
import SwiftData

@main
struct SpensaApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: PantryItem.self)
    }
}
