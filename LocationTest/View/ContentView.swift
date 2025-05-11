//
//  ContentView.swift
//  LocationTest
//
//  Created by Ian (US) on 10/05/2025.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    
    @State private var location = LocationManager.shared
    
    var body: some View {
        NavigationSplitView {
            List {
                ForEach(items) { item in
                    NavigationLink {
                        VStack(spacing: 5) {
                            Text("Location at \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
                            Text("Latitude: \(item.latitude)")
                            Text("Longitude: \(item.longitude)")
                            Text("Altitude: \(item.altitude)")
                            Text("Placemark: \(item.placemark)").font(.caption)
                        }
                    } label: {
                        Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                /*ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }*/
            }
        } detail: {
            Text("Select an item")
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
