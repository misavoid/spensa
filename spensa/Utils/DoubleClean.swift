//
//  DoubleClean.swift
//  spensa
//
//  Created by Misa Nthrop on 10.05.25.
//

import Foundation

extension Double {
    /// “3.0” → “3”, “3.5” → “3.5”
    var clean: String {
        truncatingRemainder(dividingBy: 1) == 0
            ? String(format: "%.0f", self)
            : String(self)
    }
}
