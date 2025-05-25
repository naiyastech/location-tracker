//
//  USerDefaultsManager.swift
//  LocationTest
//
//  Created by Ian (US) on 25/05/2025.
//

import Foundation

@Observable
class UserDefaultsManager {
    
    static let shared = UserDefaultsManager()
    
    private let locationAccuracyKey = "locationAccuracy"
    private let locationDistanceKey = "locationDistance"
    private let locationBackgroundEnabledKey = "locationBackgroundEnabled"
    
    var locationAccuracy: LocationAccuracy {
        didSet {
            UserDefaults.standard.set(locationAccuracy.rawValue, forKey: locationAccuracyKey)
        }
    }
    
    var locationDistance: LocationDistance {
        didSet {
            UserDefaults.standard.set(locationDistance.rawValue, forKey: locationDistanceKey)
        }
    }
    
    var locationBackgroundEnabled: Bool {
        didSet {
            UserDefaults.standard.set(locationBackgroundEnabled, forKey: locationBackgroundEnabledKey)
        }
    }
    
    private init() {
        let accuracyRawValue = UserDefaults.standard.string(forKey: locationAccuracyKey) ?? LocationAccuracy.best.rawValue
        self.locationAccuracy = LocationAccuracy(rawValue: accuracyRawValue) ?? .kilometer
        
        let distanceRawValue = UserDefaults.standard.double(forKey: locationDistanceKey)
        self.locationDistance = LocationDistance(rawValue: distanceRawValue) ?? .fiveHundredMeters
        
        if UserDefaults.standard.object(forKey: locationBackgroundEnabledKey) == nil {
            UserDefaults.standard.set(true, forKey: locationBackgroundEnabledKey)
        }
        self.locationBackgroundEnabled = UserDefaults.standard.bool(forKey: locationBackgroundEnabledKey)
    }
}
