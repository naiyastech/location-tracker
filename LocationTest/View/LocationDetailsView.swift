//
//  LocationDetailsView.swift
//  LocationTest
//
//  Created by Ian (US) on 11/05/2025.
//

import SwiftUI

struct LocationDetailsView: View {
    
    var item: Item
    
    var body: some View {
        
        List {
            
            HStack() {
                Text("Date and time:")
                Spacer()
                Text("\(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
            }
            
            HStack() {
                Text("Latitude:")
                Spacer()
                Text("\(item.latitude)")
            }
            
            HStack() {
                Text("Longitude:")
                Spacer()
                Text("\(item.longitude)")
            }
            
            HStack() {
                Text("Altitude (m):")
                Spacer()
                Text("\(item.altitude)")
            }
            
            Text("\(item.placemark)").font(.caption)
        }
        .navigationTitle("Location Details")
    }
    
}
