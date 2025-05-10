//
//  AddItemView.swift
//  spensa
//
//  Created by Misa Nthrop on 10.05.25.
//

import SwiftUI
import SwiftData

struct AddItemView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context

    @State private var name = ""
    @State private var quantityString = "1"
    @State private var unit: QuantityUnit = .piece   // ← updated
    @State private var expirationDate = Date()

    var body: some View {
        NavigationStack {
            Form {
                Section("Item Info") {
                    TextField("Name", text: $name)

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
                        let item = PantryItem(
                            name: name,
                            quantity: qty,
                            unit: unit,                    // ← works now
                            expirationDate: expirationDate
                        )
                        context.insert(item)
                        dismiss()
                    }
                    .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
            .navigationTitle("Add Item")
            }
    }
}

#Preview {
    AddItemView()
        .modelContainer(for: PantryItem.self, inMemory: true)
}
