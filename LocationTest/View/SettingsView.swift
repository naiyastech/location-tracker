//
//  Settings.swift
//  LocationTest
//
//  Created by Ian (US) on 11/05/2025.
//

import SwiftUI

struct SettingsView: View {
    
    @State private var location = LocationManager.shared
    @State private var desiredAccuracy: LocationAccuracy = .kilometer
    
    var body: some View {
        
        List {
            settingAccuracy
            
        }
        .navigationTitle("Settings")
        .onAppear {
            // Refresh preferences
        }
        
    }
    
    var settingAccuracy: some View {
        HStack {
            Picker("Accuracy:", selection: $desiredAccuracy) {
                ForEach(LocationAccuracy.allCases, id: \.self) { accuracy in
                    Text(accuracy.rawValue).tag(accuracy)
                }
            }
            .pickerStyle(.menu)
        }
    }
    
    
}


#Preview {
    SettingsView()
}
