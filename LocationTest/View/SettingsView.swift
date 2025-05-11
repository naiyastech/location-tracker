//
//  Settings.swift
//  LocationTest
//
//  Created by Ian (US) on 11/05/2025.
//

import SwiftUI

struct SettingsView: View {
    
    @State private var location = LocationManager.shared
    
    var body: some View {
        
        List {
            Text("Hello, World!")
        }
        .navigationTitle("Settings")
        
    }
}

#Preview {
    SettingsView()
}
