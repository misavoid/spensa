//
//  ContentView.swift
//  spensa
//
//  Created by Misa Nthrop on 10.05.25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [.mint.opacity(0.3), .white],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                VStack(spacing: 24) {
                    Text("Spensa")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.primary)

                    Image(systemName: "cabinet.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.accentColor)

                    LazyVGrid(
                        columns: [ GridItem(.flexible()), GridItem(.flexible()) ],
                        spacing: 20
                    ) {
                        // 1️⃣ Pantry
                        NavigationLink {
                            PantryView()
                        } label: {
                            HomeButton(title: "Pantry", icon: "cart.fill")
                        }


                        // 2️⃣ Add Item – this one actually navigates
                        NavigationLink {
                            AddItemView()
                        } label: {
                            HomeButton(title: "Add Item", icon: "plus.circle.fill")
                        }

                        // 3️⃣ Shopping List – placeholder
                        HomeButton(title: "Shopping List", icon: "list.bullet.clipboard.fill")

                        // 4️⃣ Settings – placeholder
                        HomeButton(title: "Settings", icon: "gearshape.fill")
                    }
                    .padding(.top, 16)
                }
                .padding()
            }
            // .navigationBarHidden(true)
        }
    }
}

struct HomeButton: View {
    var title: String
    var icon: String

    var body: some View {
        VStack {
            Image(systemName: icon)
                .resizable()
                .frame(width: 40, height: 40)
                .padding()
                .background(.ultraThinMaterial)
                .clipShape(Circle())

            Text(title)
                .font(.headline)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

#Preview {
    ContentView()
        .modelContainer(for: PantryItem.self, inMemory: true)
}
