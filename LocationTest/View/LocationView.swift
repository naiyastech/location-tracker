//
//  LocationsView.swift
//  LocationTest
//
//  Created by Ian (US) on 11/05/2025.
//

import SwiftUI
import SwiftData

struct LocationView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    
    var body: some View {
        
        if items.isEmpty {
            
            Text("No location data available.")
                .font(.title)
                .foregroundStyle(.secondary)
                .padding()
            
        } else {
            
            List {
                ForEach(items) { item in
                    NavigationLink {
                        LocationDetailsView(item: item)
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
            }
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
    LocationView()
        .modelContainer(for: Item.self, inMemory: true)
}
