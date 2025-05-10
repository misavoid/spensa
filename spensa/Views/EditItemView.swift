//
//  EditItemView.swift
//  spensa
//
//  Created by Misa Nthrop on 10.05.25.
//

import SwiftUI
import SwiftData

struct EditItemView: View {
    @Bindable var item: PantryItem
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Section("Item Info") {
                    TextField("Name", text: $item.name)

                    HStack {
                        TextField("Qty", value: $item.quantity, format: .number)
                            .keyboardType(.decimalPad)
                            .frame(width: 80)
                        Picker("", selection: $item.unit) {
                            ForEach(QuantityUnit.allCases) { u in
                                Text(u.displayName).tag(u)
                            }
                        }
                        .pickerStyle(.menu)
                    }

                    DatePicker(
                        "Expiration Date",
                        selection: $item.expirationDate,
                        displayedComponents: .date
                    )
                }
            }
            .navigationTitle("Edit Item")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { dismiss() }
                }
            }
        }
    }
}

#Preview {
    // mock a sample item
    let item = PantryItem(
        name: "Sample",
        quantity: 2,
        unit: .gram,
        expirationDate: .now
    )
    return EditItemView(item: item)
        .modelContainer(for: PantryItem.self, inMemory: true)
}
