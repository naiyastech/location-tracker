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
            HStack {
                Text("Timestamp:")
                Spacer()
                Text("\(item.timestamp.ISO8601Format())")
            }
            Section("Coordinates") {
                HStack {
                    Text("Latitude:")
                    Spacer()
                    Text("\(item.latitude)")
                }
                HStack {
                    Text("Longitude:")
                    Spacer()
                    Text("\(item.longitude)")
                }
                HStack {
                    Text("Altitude:")
                    Spacer()
                    Text("\(item.altitude)")
                }
            }
            Section("Location Info") {
                HStack {
                    Text("Country:")
                    Spacer()
                    Text("\(item.isoCountry ?? "N/A")")
                }
                HStack {
                    Text("State:")
                    Spacer()
                    Text("\(item.state ?? "N/A")")
                }
                HStack {
                    Text("City:")
                    Spacer()
                    Text("\(item.city ?? "N/A")")
                }
                
                Text("\(item.placemark)")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            
        }
        .navigationTitle("Details")
    }
    
}
