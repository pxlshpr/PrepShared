import Foundation

public enum BiometricStatus {
    case synced
    case syncFailing
    case manual
}

public extension BiometricStatus {
    func message(for type: BiometricType) -> String {
        switch self {
        case .synced:
            "Your \(type.abbreviation) is synced with the Health app and will automatically re-calculate any dependent goals when it changes."
        case .syncFailing:
            "Make sure you have allowed Prep to read your \(type.abbreviation) data in Settings > Privacy & Security > Health > Prep."
        case .manual:
            "Your will have to manually keep your \(type.abbreviation) updated here."
        }
    }
}
