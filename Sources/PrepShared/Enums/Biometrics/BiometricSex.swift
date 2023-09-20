import Foundation

public enum BiometricSex: Int16, Codable, CaseIterable {
    case female = 1
    case male
    case other
}

public extension BiometricSex {
    
    var name: String {
        switch self {
        case .female:   "female"
        case .male:     "male"
        case .other:    "other"
        }
    }
}

import HealthKit

extension BiometricSex: Pickable {
    public var pickedTitle: String { self.name }
    public var menuTitle: String { self.name }
    public static var `default`: BiometricSex { .female }
}

public extension BiometricSex {
    var hkBiologicalSex: HKBiologicalSex {
        switch self {
        case .female:   .female
        case .male:     .male
        case .other:    .other
        }
    }
}

public extension HKBiologicalSex {
    var biometricSex: BiometricSex {
        switch self {
        case .female:   .female
        case .male:     .male
        default:        .other
        }
    }
}
