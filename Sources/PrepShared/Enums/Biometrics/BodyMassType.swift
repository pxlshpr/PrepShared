import Foundation

public enum BodyMassType: Int16, Hashable, Codable, CaseIterable, Identifiable {
    case weight = 1
    case leanMass
    
    public var id: Int16 { rawValue }
}

public extension BodyMassType {
    
    var name: String {
        switch self {
        case .weight:   "Weight"
        case .leanMass: "Lean body mass"
        }
    }

    var abbreviation: String {
        switch self {
        case .weight:   "Weight"
        case .leanMass: "LBM"
        }
    }

    var pickerPrefix: String {
        "of "
    }
}
