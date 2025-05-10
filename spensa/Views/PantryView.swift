import SwiftUI
import SwiftData

struct PantryView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss   // now tied to the parent stack
    @Query(
      sort: [ SortDescriptor(\PantryItem.expirationDate, order: .forward) ]
    )
    private var items: [PantryItem]

    @State private var showingAddSheet = false

    var body: some View {
        List {
            if items.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "cart")
                      .font(.largeTitle)
                      .foregroundStyle(.secondary)
                    Text("Your pantry is empty")
                      .font(.headline)
                      .foregroundColor(.secondary)
                    Button("Add your first item") {
                      showingAddSheet = true
                    }
                    .buttonStyle(.borderedProminent)
                }
                .frame(maxWidth: .infinity, minHeight: 200)
            } else {
                ForEach(items) { item in
                            NavigationLink {
                                EditItemView(item: item)
                            } label: {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(item.name)
                                            .font(.headline)
                                        Text("Qty: \(item.quantity.clean) \(item.unit.displayName)")
                                            .font(.subheadline)
                                    }
                                    Spacer()
                                    Text(item.expirationDate, style: .date)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                .padding(.vertical, 4)
                            }
                        }
                        .onDelete(perform: deleteItems)
            }
        }
        .navigationTitle("Pantry")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            // ← + button to add more items
            ToolbarItem(placement: .navigationBarTrailing) {
                Button { showingAddSheet = true } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddSheet) {
            // we still need a nav stack here so AddItemView has its own Cancel/Save bar
            NavigationStack {
                AddItemView()
            }
        }
    }

    private func deleteItems(at offsets: IndexSet) {
        for idx in offsets { context.delete(items[idx]) }
    }
}

#Preview {
    PantryView()
      .modelContainer(for: PantryItem.self, inMemory: true)
}
