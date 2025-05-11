//
//  ContentView.swift
//  LocationTest
//
//  Created by Ian (US) on 10/05/2025.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        NavigationStack {
            List {
                NavigationLink(destination: LocationView()) {
                    Text("Location Data")
                }
                
                NavigationLink(destination: SettingsView()) {
                    Text("Settings")
                }
            }
            .navigationTitle("Data Options")
        }
    }

    
}

#Preview {
    ContentView()
        
}
