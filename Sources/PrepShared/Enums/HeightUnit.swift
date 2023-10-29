import Foundation

public let InchesPerFoot: Double = 12

public enum HeightUnit: Int, CaseIterable, Codable {
    case cm = 1
    case ft
    case m
}

extension HeightUnit: Pickable {
    public var pickedTitle: String { abbreviation }
    public var menuTitle: String { name }
    public static var `default`: HeightUnit { .cm }
}

public extension HeightUnit {
    var name: String {
        switch self {
        case .m:
            return "meters"
        case .cm:
            return "centimeters"
        case .ft:
            return "feet"
        }
    }
    
    var abbreviation: String {
        switch self {
        case .cm:
            return "cm"
        case .ft:
            return "ft"
        case .m:
            return "m"
        }
    }
}

public extension HeightUnit {
    var cm: Double {
        switch self {
        case .cm:
            return 1
        case .ft:
            return 30.48
        case .m:
            return 100
        }
    }
    
    func convert(_ value: Double, to other: HeightUnit) -> Double {
        let inCm = value * self.cm
        return inCm / other.cm
    }
}

import HealthKit

public extension HeightUnit {
    
    var healthKitUnit: HKUnit {
        switch self {
        case .cm:
            return .meterUnit(with: .centi)
        case .ft:
            return .foot()
        case .m:
            return .meter()
        }
    }
}
