//
//  BarcodeScannerView.swift
//  spensa
//
//  Created by Misa Nthrop on 11.05.25.
//

import SwiftUI
import SwiftData
import CodeScanner

// Model for OpenFoodFacts API response
struct OpenFoodFactsResponse: Decodable {
    let status: Int
    let product: ProductData?

    struct ProductData: Decodable {
        let product_name: String?
        let quantity: String?
        let brands: String?
        let image_url: String?
    }
}

/// A view that scans a barcode and fetches product info from OpenFoodFacts
struct BarcodeScannerView: View {
    @State private var isPresentingScanner = false
    @State private var barcode: String = ""
    @State private var fetching = false
    @State private var fetchError: String?
    @State private var productName: String = ""
    @State private var productUnit: String = "pcs"

    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                if fetching {
                    ProgressView("Fetching product…")
                } else if !productName.isEmpty {
                    Text("Found: \(productName)")
                        .font(.headline)
                    Button("Add to Pantry") {
                        // Insert into SwiftData
                        let quantityValue = 1.0
                        let item = PantryItem(name: productName,
                                               quantity: quantityValue,
                                               unit: .piece,
                                               expirationDate: Date())
                        context.insert(item)
                        dismiss()
                    }
                } else if let error = fetchError {
                    Text("Error: \(error)")
                        .foregroundColor(.red)
                } else {
                    Text("No product scanned yet")
                        .foregroundColor(.secondary)
                }

                Spacer()
            }
            .navigationTitle("Scan Barcode")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Scan") { isPresentingScanner = true }
                }
            }
            .sheet(isPresented: $isPresentingScanner) {
                CodeScannerView(
                    codeTypes: [.ean13],
                    completion: handleScan
                )
            }
        }
    }

    private func handleScan(result: Result<ScanResult, ScanError>) {
        isPresentingScanner = false
        switch result {
        case .success(let scan):
            barcode = scan.string
            fetchProduct(barcode: barcode)
        case .failure:
            fetchError = "Scanning failed"
        }
    }

    private func fetchProduct(barcode: String) {
        fetching = true
        fetchError = nil
        productName = ""

        let urlString = "https://world.openfoodfacts.org/api/v0/product/\(barcode).json"
        guard let url = URL(string: urlString) else {
            fetchError = "Invalid URL"
            fetching = false
            return
        }

        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let response = try JSONDecoder().decode(OpenFoodFactsResponse.self, from: data)
                if response.status == 1, let product = response.product, let name = product.product_name {
                    productName = name
                } else {
                    fetchError = "Product not found"
                }
            } catch {
                fetchError = error.localizedDescription
            }
            fetching = false
        }
    }
}

#if DEBUG
struct BarcodeScannerView_Previews: PreviewProvider {
    static var previews: some View {
        BarcodeScannerView()
            .modelContainer(for: PantryItem.self, inMemory: true)
    }
}
#endif
