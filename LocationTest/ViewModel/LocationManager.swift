//
//  LocationManager.swift
//  LocationTest
//
//  Created by Ian (US) on 10/05/2025.
//
import Foundation
import SwiftData
import CoreLocation
import Observation

@Observable
class LocationManager: NSObject, CLLocationManagerDelegate {
    
    static let shared = LocationManager()
    let manager: CLLocationManager = CLLocationManager()
    
    override init() {
        super.init()
        self.manager.delegate = self
        configureLocationManager()
        
    }
    
    func configureLocationManager() {
        let userDefaults = UserDefaultsManager.shared
        manager.desiredAccuracy = userDefaults.locationAccuracy.clAccuracy
        print("Configure manager: \(userDefaults.locationAccuracy.description)")
        manager.distanceFilter = userDefaults.locationDistance.clDistance
        print("Configure manager: \(userDefaults.locationDistance.description)")
        manager.allowsBackgroundLocationUpdates = userDefaults.locationBackgroundEnabled
        print("Configure manager: \(userDefaults.locationBackgroundEnabled.description)")
        manager.pausesLocationUpdatesAutomatically = false
        manager.delegate = self
    }
    
    func updateSettings(_ newSettings: LocationSettings) {
        let userDefaults = UserDefaultsManager.shared
        
        // Update UserDefaults with the new settings
        userDefaults.locationAccuracy = newSettings.locationAccuracy
        print("Update default: \(userDefaults.locationAccuracy.description)")
        userDefaults.locationDistance = newSettings.locationDistance
        print("Update default: \(userDefaults.locationDistance.description)")
        userDefaults.locationBackgroundEnabled = newSettings.locationBackgroundEnabled
        print("Update default: \(userDefaults.locationBackgroundEnabled.description)")
        
        // Reconfigure the CLLocationManager with the updated settings
        configureLocationManager()
    }
    
    func accuracyAuthorization() -> String {
        switch manager.accuracyAuthorization {
        case .fullAccuracy:
            return "Full Accuracy"
        case .reducedAccuracy:
            return "Reduced Accuracy"
        @unknown default:
            return "Unknown Accuracy"
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestAlwaysAuthorization()
        case .restricted:
            print("Location restricted")
        case .denied:
            print("Location denied")
        case .authorizedWhenInUse:
            print("Location when in use")
        case .authorizedAlways:
            print("Location always")
            manager.startUpdatingLocation()
        @unknown default:
            print(manager.authorizationStatus.rawValue)
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locations.last.map {
            
            logLocationToModel(location: $0)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print(error)
    }
    
    func logLocationToModel(location: CLLocation) {
        Task {
            var placemark = "Unknown"
            var locationCountry = "XX"
            var locationState = "Unknown"
            var locationCity = "Unknown"
            do {
                let (city, state, country) = try await LocationManager.shared.reverseGeocode(location: location)
                placemark = "City: \(city), State: \(state), Country: \(country)"
                locationCountry = country
                locationState = state
                locationCity = city
            } catch {
                print("Failed to reverse geocode: \(error)")
            }
            
            do {
                let locationItem = Item(timestamp: Date(),
                                        latitude: location.coordinate.latitude,
                                        longitude: location.coordinate.longitude,
                                        altitude: location.altitude,
                                        placemark: placemark,
                                        isoCountry: locationCountry,
                                        state: locationState,
                                        city: locationCity)
                
                let context = try ModelContext(ModelContainer(for: Item.self))
                context.insert(locationItem)
                try context.save()
            } catch {
                print("Failed to save item: \(error)")
            }
        }
    }

    func reverseGeocode(location: CLLocation) async throws -> (city: String, state: String, country: String) {
        let geocoder = CLGeocoder()
        return try await withCheckedThrowingContinuation { continuation in
            geocoder.reverseGeocodeLocation(location) { placemarks, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                guard let placemark = placemarks?.first else {
                    continuation.resume(throwing: NSError(domain: "LocationManager", code: 0, userInfo: [NSLocalizedDescriptionKey: "No placemark found"]))
                    return
                }
                
                let city = placemark.locality ?? "Unknown City"
                let state = placemark.administrativeArea ?? "Unknown State"
                let country = placemark.isoCountryCode ?? "XX"
                let timezone = placemark.timeZone ?? .none
                
                continuation.resume(returning: (city, state, country))
            }
        }
    }


}
