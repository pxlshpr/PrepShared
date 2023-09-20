import Foundation

let PoundsPerStone: Double = 14

public enum BodyMassUnit: Int16, CaseIterable, Codable, Identifiable {
    case kg = 1
    case lb
    case st
    
    public var id: Int16 { rawValue }
}

public extension BodyMassUnit {
    var g: Double {
        switch self {
        case .kg:
            return 1000
        case .lb:
            return 453.59237
        case .st:
            return 6350.29318
        }
    }
    func convert(_ value: Double, to other: BodyMassUnit) -> Double {
        let inGrams = value * self.g
        return inGrams / other.g
    }
}

public extension BodyMassUnit {
    var name: String {
        switch self {
        case .kg:
            return "kilogram"
        case .lb:
            return "pound"
        case .st:
            return "stone"
        }
    }

    var abbreviation: String {
        switch self {
        case .kg:
            return "kg"
        case .lb:
            return "lb"
        case .st:
            return "st"
        }
    }
    
    var pickerPrefix: String {
        "per "
    }
}

import HealthKit

public extension BodyMassUnit {
    var healthKitUnit: HKUnit {
        switch self {
        case .kg:
            return .gramUnit(with: .kilo)
        case .lb:
            return .pound()
        case .st:
            return .stone()
        }
    }
}

public extension WeightUnit {
    func convert(_ value: Double, to other: WeightUnit) -> Double {
        let inGrams = value * self.g
        return inGrams / other.g
    }
}
