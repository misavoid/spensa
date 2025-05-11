//
//  ShoppingListView.swift
//  spensa
//
//  Created by Misa Nthrop on 11.05.25.
//

import SwiftUI

struct ShoppingListView: View {
    var body: some View {
        Text("🛒 Your shopping list is empty")
            .font(.title2)
            .foregroundStyle(.secondary)
            .navigationTitle("Shopping List")
    }
}

#Preview {
    NavigationStack {
        ShoppingListView()
    }
}
