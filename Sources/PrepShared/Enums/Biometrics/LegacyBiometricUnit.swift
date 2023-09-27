import Foundation


public enum LegacyBiometricUnit {
    case energy(EnergyUnit)
    case bodyMass(BodyMassUnit)
    case height(HeightUnit)
    case years
    case percentage
}

public extension LegacyBiometricUnit {
    var description: String {
        switch self {
        case .energy(let energyUnit):
            return energyUnit.abbreviation
        case .bodyMass(let bodyMassUnit):
            return bodyMassUnit.abbreviation
        case .height(let heightUnit):
            return heightUnit.abbreviation
        case .years:
            return "years"
        case .percentage:
            return "%"
        }
    }
    
    var energyUnit: EnergyUnit? {
        switch self {
        case .energy(let energyUnit):
            return energyUnit
        default:
            return nil
        }
    }
    var bodyMassUnit: BodyMassUnit? {
        switch self {
        case .bodyMass(let bodyMassUnit):
            return bodyMassUnit
        default:
            return nil
        }
    }
    var heightUnit: HeightUnit? {
        switch self {
        case .height(let heightUnit):
            return heightUnit
        default:
            return nil
        }
    }
    
    var hasTwoComponents: Bool {
        switch self {
        case .bodyMass(let bodyMassUnit):
            return bodyMassUnit == .st
        case .height(let heightUnit):
            return heightUnit == .ft
        default:
            return false
        }
    }
}
