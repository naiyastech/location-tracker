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
    
    init(timestamp: Date, latitude: Double, longitude: Double) {
        self.timestamp = timestamp
        self.latitude = latitude
        self.longitude = longitude
    }
}
