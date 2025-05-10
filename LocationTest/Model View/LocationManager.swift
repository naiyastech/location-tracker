//
//  LocationManager.swift
//  LocationTest
//
//  Created by Ian (US) on 10/05/2025.
//
import Foundation
import SwiftData
import MapKit
import Observation

@Observable
class LocationManager: NSObject, CLLocationManagerDelegate {
    
    static let shared = LocationManager()
    let manager: CLLocationManager = CLLocationManager()
    var region: MKCoordinateRegion = MKCoordinateRegion()
    
    override init() {
        super.init()
        self.manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
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
            region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: $0.coordinate.latitude, longitude: $0.coordinate.longitude),
                                        span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
            
            logLocationToModel(location: $0)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print(error)
    }
    
    func logLocationToModel(location: CLLocation) {
        let locationItem = Item(timestamp: Date(),
                                latitude: location.coordinate.latitude,
                                longitude: location.coordinate.longitude)
        do {
            let context = try ModelContext(ModelContainer(for: Item.self))
            context.insert(locationItem)
            try context.save()
        } catch {
            print("Failed to save item: \(error)")
        }
    }
    
}
