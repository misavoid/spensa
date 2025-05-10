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
    @State private var quantity = 1
    @State private var expirationDate = Date()

    var body: some View {
        NavigationStack {
            Form {
                Section("Item Info") {
                    TextField("Name", text: $name)
                    Stepper("Quantity: \(quantity)", value: $quantity, in: 1...999)
                    DatePicker("Expiration Date", selection: $expirationDate, displayedComponents: .date)
                }

                Section {
                    Button("Save") {
                        let item = PantryItem(name: name,
                                              quantity: quantity,
                                              expirationDate: expirationDate)
                        context.insert(item)
                        dismiss()
                    }
                    .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
            .navigationTitle("Add Item")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}
