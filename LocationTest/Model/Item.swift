//
//  Item.swift
//  LocationTest
//
//  Created by Ian (US) on 10/05/2025.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    var latitude: Double
    var longitude: Double
    var altitude: Double
    var placemark: String
    
    init(timestamp: Date, latitude: Double, longitude: Double, altitude: Double, placemark: String) {
        self.timestamp = timestamp
        self.latitude = latitude
        self.longitude = longitude
        self.altitude = altitude
        self.placemark = placemark
    }
}
