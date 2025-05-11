//
//  README.md
//  spensa
//
//  Created by Misa Nthrop on 11.05.25.
//

[![Swift](https://img.shields.io/badge/Swift-5.8-orange.svg)](https://swift.org)
[![iOS](https://img.shields.io/badge/iOS-17.0%2B-blue.svg)](https://developer.apple.com/ios)

# Spensa

A no-BS pantry manager built in SwiftUI + SwiftData. Scan barcodes, track quantities & expirations, and never toss a mystery can in the back of your kitchen again.

---

## 🚀 Features

- **Dashboard**
  High-level stats & quick actions on your pantry
  (see `DashboardView.swift`) :contentReference[oaicite:0]{index=0}:contentReference[oaicite:1]{index=1}

- **Pantry List**
  Sorted by expiration date, swipe-to-delete, empty-state prompt
  (`PantryView.swift`) :contentReference[oaicite:2]{index=2}:contentReference[oaicite:3]{index=3}

- **Add Item**
  • Manual entry of name, qty & unit
  • DatePicker for expiration
  • **Barcode scan** (EAN-13) + OpenFoodFacts lookup → auto-fill name/qty (`AddItemView.swift`) :contentReference[oaicite:4]{index=4}:contentReference[oaicite:5]{index=5}
  • Separate `BarcodeScannerView` with success/error UI (`BarcodeScannerView.swift`) :contentReference[oaicite:6]{index=6}:contentReference[oaicite:7]{index=7}

- **Edit Item**
  In-place binding of `PantryItem` properties, “Save” auto-persists to SwiftData
  (`EditItemView.swift`) :contentReference[oaicite:8]{index=8}:contentReference[oaicite:9]{index=9}

- **Shopping List** & **Search** placeholders
  Coming soon — scaffolded for easy expansion
  (`ShoppingListView.swift`, `SearchView.swift`) :contentReference[oaicite:10]{index=10}

---

## 📦 Tech Stack

- **UI:** SwiftUI
- **Persistence:** SwiftData models + `@Query` / `@Bindable`
- **Scanning:** [CodeScanner](https://github.com/twostraws/CodeScanner)
- **Networking:** `async`/`await` + `URLSession` → decode `OpenFoodFactsResponse` :contentReference[oaicite:11]{index=11}:contentReference[oaicite:12]{index=12}

---

## 🛠 Getting Started

1. **Clone**
   ```bash
   git clone https://github.com/misavoid/spensa.git
   cd spensa
