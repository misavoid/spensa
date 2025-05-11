//
//  DashboardView.swift
//  spensa
//
//  Created by Misa Nthrop on 11.05.25.
//

import SwiftUI

struct DashboardView: View {
    // MARK: – Replace these with real @Query‐driven values
    let totalItems = 12
    let expiringSoon = 3
    let lowStock = 2
    let categoriesCount = 5
    let expiringCategories = ["Grains", "Dairy", "Spices"]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    
                    // Header
                    VStack(spacing: 4) {
                        Text("spensa")
                            .font(.largeTitle.weight(.bold))
                        Text("Hello, Chef!")
                            .font(.title3)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.top)
                    
                    // Today's Summary
                    SummaryCard(
                        stats: [
                            ("Items total", "\(totalItems)"),
                            ("Expiring soon", "\(expiringSoon)"),
                            ("Low stock", "\(lowStock)"),
                            ("Categories", "\(categoriesCount)")
                        ]
                    )
                    
                    // Quick Actions
                    QuickActionsGrid()
                    
                    // Expiring Soon
                    ExpiringSoonRow(categories: expiringCategories)
                    
                    Spacer()
                }
                .padding(.horizontal)
            }
            .navigationBarHidden(true)
        }
    }
}


// MARK: – Components

struct SummaryCard: View {
    let stats: [(label: String, value: String)]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Today's Summary")
                .font(.headline)
            HStack(spacing: 16) {
                ForEach(stats, id: \.label) { stat in
                    VStack {
                        Text(stat.value)
                            .font(.title2.weight(.semibold))
                        Text(stat.label)
                            .font(.caption)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(16)
    }
}

struct QuickActionsGrid: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Quick Actions")
                .font(.headline)
            
            LazyVGrid(columns: [GridItem(), GridItem()], spacing: 16) {
                NavigationLink(destination: AddItemView()) {
                    ActionButton(icon: "plus.circle.fill", title: "Add Item", color: .red.opacity(0.2))
                }
                NavigationLink(destination: SearchView()) {
                    ActionButton(icon: "magnifyingglass", title: "Search", color: .green.opacity(0.2))
                }
                NavigationLink(destination: PantryView()) {
                    ActionButton(icon: "archivebox.fill", title: "Pantry", color: .blue.opacity(0.2))
                }
                NavigationLink(destination: ShoppingListView()) {
                    ActionButton(icon: "cart.fill", title: "Shopping List", color: .purple.opacity(0.2))
                }
            }
        }
    }
}

struct ActionButton: View {
    let icon: String
    let title: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.title2)
                .frame(width: 32, height: 32)
            Text(title)
                .font(.subheadline.weight(.semibold))
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(color)
        .cornerRadius(12)
    }
}

struct ExpiringSoonRow: View {
    let categories: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Expiring Soon")
                .font(.headline)
            HStack {
                ForEach(categories, id: \.self) { cat in
                    Text(cat)
                        .font(.caption.weight(.semibold))
                        .padding(.vertical, 6)
                        .padding(.horizontal, 12)
                        .background(.ultraThinMaterial)
                        .cornerRadius(12)
                }
            }
        }
    }
}


// MARK: – Preview

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
