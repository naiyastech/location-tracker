import CoreLocation

struct LocationSettings: Codable {
    var locationAccuracy: LocationAccuracy
    var locationDistance: LocationDistance
    var locationBackgroundEnabled: Bool
}


enum LocationAccuracy: String, CaseIterable, Codable {
    case best = "Best"
    case nearestTenMeters = "NearestTenMeters"
    case hundredMeters = "HundredMeters"
    case kilometer = "Kilometer"
    case threeKilometers = "ThreeKilometers"
    
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
    
    var description: String {
        switch self {
        case .best:
            return "Best"
        case .nearestTenMeters:
            return "Nearest 10 meters"
        case .hundredMeters:
            return "100 meters"
        case .kilometer:
            return "1 kilometer"
        case .threeKilometers:
            return "3 kilometers"
        }
    }
}

enum LocationDistance: Double, CaseIterable, Codable {
    case fiftyMeters = 50
    case hundredMeters = 100
    case fiveHundredMeters = 500
    case kilometer = 1000
    case fifteenHundredMeters = 1500
    case twoKilometers = 2000
    case threeKilometers = 3000
    
    var clDistance: CLLocationDistance {
        return self.rawValue
    }
    
    var description: String {
            switch self {
            case .fiftyMeters:
                return "50 meters"
            case .hundredMeters:
                return "100 meters"
            case .fiveHundredMeters:
                return "500 meters"
            case .kilometer:
                return "1 kilometer"
            case .fifteenHundredMeters:
                return "1.5 kilometers"
            case .twoKilometers:
                return "2 kilometers"
            case .threeKilometers:
                return "3 kilometers"
            }
        }
}

