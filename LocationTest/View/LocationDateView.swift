//
//  LocationDateView.swift
//  LocationTest
//
//  Created by Ian (US) on 26/05/2025.
//
import SwiftUI

struct LocationDateView: View {
    let date: Date
    let items: [Item]
    
    var body: some View {
        List {
            ForEach(items, id: \.self) { item in
                NavigationLink {
                    LocationDetailsView(item: item)
                } label: {
                    Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
                }
            }
            .onDelete(perform: deleteItems)
        }
        .navigationTitle("\(date, format: Date.FormatStyle(date: .numeric, time: .omitted))")
        //.navigationBarTitleDisplayMode(.inline)
    }
    
    private func deleteItems(offsets: IndexSet) {
        // Omit
    }
}
