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
    var isoCountry: String?
    var state: String?
    var city: String?
    
    var day: Date {
        Calendar.current.startOfDay(for: timestamp)
    }
    
    init(timestamp: Date,
         latitude: Double,
         longitude: Double,
         altitude: Double,
         placemark: String,
         isoCountry: String? = nil,
         state: String? = nil,
         city: String? = nil) {
        self.timestamp = timestamp
        self.latitude = latitude
        self.longitude = longitude
        self.altitude = altitude
        self.placemark = placemark
        self.isoCountry = isoCountry
        self.state = state
        self.city = city
    }
}
