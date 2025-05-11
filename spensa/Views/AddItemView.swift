//
//  AddItemView.swift
//  spensa
//
//  Created by Misa Nthrop on 10.05.25.
//

import SwiftUI
import SwiftData
import CodeScanner

struct AddItemView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context

    @Query(sort: [SortDescriptor(\PantryItem.name, order: .forward)])
    private var allItems: [PantryItem]

    @State private var name = ""
    @State private var quantityString = "1"
    @State private var unit: QuantityUnit = .piece
    @State private var expirationDate = Date()

    @State private var isPresentingScanner = false
    @State private var scanError: String?
    @State private var scanningSuccess = false

    var body: some View {
        NavigationStack {
            Form {
                Section("Item Info") {
                    HStack {
                        TextField("Name", text: $name)
                        Button {
                            isPresentingScanner = true
                        } label: {
                            Image(systemName: "barcode.viewfinder")
                        }
                        .buttonStyle(.borderless)
                        .help("Scan barcode")
                    }

                    HStack {
                        TextField("Qty", text: $quantityString)
                            .keyboardType(.decimalPad)
                            .frame(width: 80)
                        Picker("", selection: $unit) {
                            ForEach(QuantityUnit.allCases) { u in
                                Text(u.displayName).tag(u)
                            }
                        }
                        .pickerStyle(.menu)
                    }

                    DatePicker(
                        "Expiration Date",
                        selection: $expirationDate,
                        displayedComponents: .date
                    )
                }

                Section {
                    Button("Save") {
                        let qty = Double(quantityString) ?? 1
                        if let existing = allItems.first(where: { $0.name.lowercased() == name.lowercased() }) {
                            existing.quantity += qty
                        } else {
                            let item = PantryItem(
                                name: name,
                                quantity: qty,
                                unit: unit,
                                expirationDate: expirationDate
                            )
                            context.insert(item)
                        }
                        dismiss()
                    }
                    .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
            .navigationTitle("Add Item")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
            }
            .fullScreenCover(isPresented: $isPresentingScanner) {
                ZStack {
                    CodeScannerView(
                        codeTypes: [.ean13],
                        scanMode: .once,
                        completion: handleScan
                    )
                    .edgesIgnoringSafeArea(.all)

                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            scanningSuccess ? Color.green : Color.white.opacity(0.7),
                            lineWidth: 4
                        )
                        .padding(32)
                }
                .overlay {
                    if scanningSuccess {
                        Text("✅ Scanned!")
                            .font(.headline)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            .background(.black.opacity(0.7))
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .transition(.opacity)
                            .zIndex(1)
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel") {
                            isPresentingScanner = false
                        }
                    }
                }
            }
        }
    }

    private func handleScan(result: Result<ScanResult, ScanError>) {
        switch result {
        case .success(let scan):
            scanningSuccess = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                isPresentingScanner = false
                fetchOpenFoodFacts(for: scan.string)
                scanningSuccess = false
            }
        case .failure(let error):
            scanError = error.localizedDescription
            isPresentingScanner = false
        }
    }

    private func fetchOpenFoodFacts(for barcode: String) {
        Task {
            let urlStr = "https://world.openfoodfacts.org/api/v0/product/\(barcode).json"
            guard let url = URL(string: urlStr) else { return }
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let resp = try JSONDecoder().decode(OpenFoodFactsResponse.self, from: data)
                if resp.status == 1,
                   let p = resp.product,
                   let pname = p.product_name {
                    name = pname
                    if let qty = p.quantity,
                       let (value, unitCode) = parseQuantity(qty) {
                        quantityString = "\(value)"
                        unit = QuantityUnit(rawValue: unitCode) ?? .piece
                    }
                } else {
                    scanError = "Product not found"
                }
            } catch {
                scanError = error.localizedDescription
            }
        }
    }

    private func parseQuantity(_ text: String) -> (Double, String)? {
        let comps = text.split(separator: " ")
        guard comps.count == 2,
              let val = Double(comps[0])
        else { return nil }
        return (val, String(comps[1]))
    }
}

#Preview {
    AddItemView()
        .modelContainer(for: PantryItem.self, inMemory: true)
}
