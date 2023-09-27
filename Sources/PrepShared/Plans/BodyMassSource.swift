import Foundation

public enum BodyMassSource: Codable, Hashable {
    case biometrics
    case custom
}

public extension BodyMassSource {
    var name: String {
        switch self {
        case .biometrics:   "Biometrics"
        case .custom:       "Custom"
        }
    }
}

extension BodyMassSource: Pickable {
    public var pickedTitle: String { name }
    public var menuTitle: String { name }
    public static var `default`: BodyMassSource { .biometrics }
}
