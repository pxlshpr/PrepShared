import Foundation

public enum RDIType: Hashable, Equatable, Codable {
    case fixed
    case quantityPerEnergy(Double, EnergyUnit)
    case percentageOfEnergy
}

public extension RDIType {
    var usesEnergy: Bool {
        switch self {
        case .quantityPerEnergy, .percentageOfEnergy:   true
        default:                                        false
        }
    }
    
    var name: String {
        switch self {
        case .fixed:                "Fixed"
        case .quantityPerEnergy:    "Quantity per energy"
        case .percentageOfEnergy:   "Percentage of energy"
        }
    }
    
    var isQuantityPerEnergy: Bool {
        switch self {
        case .quantityPerEnergy:    true
        default:                    false
        }
    }
    
    var isFixed: Bool {
        switch self {
        case .fixed:    true
        default:        false
        }
    }

    var isPercentageOfEnergy: Bool {
        switch self {
        case .percentageOfEnergy:   true
        default:                    false
        }
    }

}

extension RDIType: Pickable {
    public var pickedTitle: String { name }
    public var menuTitle: String { name }
    public static var `default`: RDIType { .fixed }
    public static var allCases: [RDIType] {
        [
            .fixed,
            .quantityPerEnergy(1000, .kcal),
            .percentageOfEnergy
        ]
    }
}
