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
}
