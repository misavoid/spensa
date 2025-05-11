//
//  SearchView.swift
//  spensa
//
//  Created by Misa Nthrop on 11.05.25.
//

import SwiftUI

struct SearchView: View {
    var body: some View {
        Text("🔍 Search coming soon")
            .font(.title2)
            .foregroundStyle(.secondary)
            .navigationTitle("Search")
    }
}

#Preview {
    NavigationStack {
        SearchView()
    }
}
