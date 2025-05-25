//
//  Settings.swift
//  LocationTest
//
//  Created by Ian (US) on 11/05/2025.
//

import SwiftUI

struct SettingsView: View {
    
    @State private var userDefaults = UserDefaultsManager.shared
    
    var body: some View {
        
        List {
            Section("Location Settings") {
                settingAccuracy
                settingDistance
                settingBackground
            }
        }
        .navigationTitle("Settings")
        .onAppear {
            // Refresh preferences
        }
        
    }
    
    var settingAccuracy: some View {
        HStack {
            Picker("Accuracy", selection: $userDefaults.locationAccuracy) {
                ForEach(LocationAccuracy.allCases, id: \.self) { accuracy in
                    Text(accuracy.description).tag(accuracy)
                }
            }
            .pickerStyle(.menu)
        }
    }
    
    var settingDistance: some View {
        HStack {
            Picker("Distance", selection: $userDefaults.locationDistance) {
                ForEach(LocationDistance.allCases, id: \.self) { distance in
                    Text(distance.description).tag(distance)
                }
            }
            .pickerStyle(.menu)
        }
    }
    
    var settingBackground: some View {
        VStack {
            Toggle("Background Updates", isOn: $userDefaults.locationBackgroundEnabled)
                .toggleStyle(SwitchToggleStyle(tint: .blue))
            Text("Enable this to allow location tracking to continue when you have closed the app. This will increase battery usage but will provide you with a complete history of your location.")
                .font(.caption)
                .foregroundStyle(Color.gray)
        }
    }
    
}


#Preview {
    SettingsView()
}
