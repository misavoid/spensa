//
//  PantryItem.swift
//  spensa
//
//  Created by Misa Nthrop on 10.05.25.
//

import Foundation
import SwiftData

/// Renamed to avoid clashing with Foundation.Unit
enum QuantityUnit: String, CaseIterable, Codable, Identifiable {
    case piece = "Pcs."
    case gram  = "Gram"
    case ml    = "Milliliter"
    case kilo  = "Kilogram"
    case liter = "Liter"

    var id: String { rawValue }
    var displayName: String { rawValue }
}

@Model
class PantryItem {
    var name: String
    var quantity: Double
    var unit: QuantityUnit        // ← updated
    var expirationDate: Date

    init(
      name: String,
      quantity: Double,
      unit: QuantityUnit = .piece, // ← updated
      expirationDate: Date
    ) {
        self.name = name
        self.quantity = quantity
        self.unit = unit
        self.expirationDate = expirationDate
    }
}
