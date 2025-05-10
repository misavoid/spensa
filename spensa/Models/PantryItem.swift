//
//  PantryItem.swift
//  spensa
//
//  Created by Misa Nthrop on 10.05.25.
//

import Foundation
import SwiftData

@Model
class PantryItem {
    var name: String
    var quantity: Int
    var expirationDate: Date

    init(name: String, quantity: Int, expirationDate: Date) {
        self.name = name
        self.quantity = quantity
        self.expirationDate = expirationDate
    }
}
