import CoreLocation

struct LocationSettings {
    var desiredAccuracy: LocationAccuracy
    var distanceFilter: CLLocationDistance
    var allowsBackgroundLocationUpdates: Bool
}

enum LocationAccuracy: String, CaseIterable, Codable {
    case best = "Best"
    case nearestTenMeters = "Nearest 10 Meters"
    case hundredMeters = "Hundred Meters"
    case kilometer = "Kilometer"
    case threeKilometers = "Three Kilometers"
    
    var clAccuracy: CLLocationAccuracy {
        switch self {
        case .best:
            return kCLLocationAccuracyBest
        case .nearestTenMeters:
            return kCLLocationAccuracyNearestTenMeters
        case .hundredMeters:
            return kCLLocationAccuracyHundredMeters
        case .kilometer:
            return kCLLocationAccuracyKilometer
        case .threeKilometers:
            return kCLLocationAccuracyThreeKilometers
        }
    }
}
