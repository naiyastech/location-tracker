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
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = 5
        manager.allowsBackgroundLocationUpdates = true
        manager.pausesLocationUpdatesAutomatically = false
        
        switch manager.authorizationStatus {
        case .notDetermined:
            self.manager.requestAlwaysAuthorization()
        case .restricted:
            print("Location access is restricted")
        case .denied:
            print("Location access is denied")
        case .authorizedWhenInUse:
            print("Location access is only when in use")
        case .authorizedAlways:
            print("Location access is always")
        default:
            print(manager.authorizationStatus.rawValue)
        }
        
        self.manager.startUpdatingLocation()
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
            do {
                let (city, state, country) = try await LocationManager.shared.reverseGeocode(location: location)
                let placemark = "City: \(city), State: \(state), Country: \(country)"
                
                let locationItem = Item(timestamp: Date(),
                                        latitude: location.coordinate.latitude,
                                        longitude: location.coordinate.longitude,
                                        altitude: location.altitude,
                                        placemark: placemark)
                
                let context = try ModelContext(ModelContainer(for: Item.self))
                context.insert(locationItem)
                try context.save()
            } catch {
                print("Failed to reverse geocode or save item: \(error)")
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
                let country = placemark.country ?? "Unknown Country"
                
                continuation.resume(returning: (city, state, country))
            }
        }
    }


}
