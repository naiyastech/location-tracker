//
//  Settings.swift
//  LocationTest
//
//  Created by Ian (US) on 11/05/2025.
//

import SwiftUI

struct SettingsView: View {
    
    @State private var locationManager = LocationManager.shared
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
            .onChange(of: userDefaults.locationAccuracy) { oldValue, newValue in
                updateLocationManagerSettings()
            }
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
            .onChange(of: userDefaults.locationDistance) { oldValue, newValue in
                updateLocationManagerSettings()
            }
        }
    }
    
    var settingBackground: some View {
        VStack {
            Toggle("Background Updates", isOn: $userDefaults.locationBackgroundEnabled)
                .toggleStyle(SwitchToggleStyle(tint: .blue))
                .onChange(of: userDefaults.locationBackgroundEnabled) { oldValue, newValue in
                    updateLocationManagerSettings()
                }
            Text("Enable this to allow location tracking to continue when you have closed the app. This will increase battery usage but will provide you with a complete history of your location.")
                .font(.caption)
                .foregroundStyle(Color.gray)
        }
    }
    
    func updateLocationManagerSettings() {
        let newSettings = LocationSettings(locationAccuracy: userDefaults.locationAccuracy,
                                           locationDistance: userDefaults.locationDistance,
                                           locationBackgroundEnabled: userDefaults.locationBackgroundEnabled)
        locationManager.updateSettings(newSettings)
    }
    
}

#Preview {
    SettingsView()
}
