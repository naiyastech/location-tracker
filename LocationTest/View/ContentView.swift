//
//  ContentView.swift
//  LocationTest
//
//  Created by Ian (US) on 10/05/2025.
//

import SwiftUI

struct ContentView: View {
    
    
    @State private var location = LocationManager.shared
    
    var body: some View {
        NavigationSplitView {
            List {
                NavigationLink(destination: LocationView()) {
                    Text("Location Data")
                }
                
                NavigationLink(destination: SettingsView()) {
                    Text("Settings")
                }
            }
            .navigationTitle("Data Options")
        } detail: {
            Text("Select an item")
        }
    }

    
}

#Preview {
    ContentView()
        
}
