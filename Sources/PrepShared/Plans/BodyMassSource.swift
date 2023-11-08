import Foundation

public enum BodyMassSource: Codable, Hashable {
    case health
    case custom
}

public extension BodyMassSource {
    var name: String {
        switch self {
        case .health:   "Health"
        case .custom:   "Custom"
        }
    }
}

extension BodyMassSource: Pickable {
    public var pickedTitle: String { name }
    public var menuTitle: String { name }
    public static var `default`: BodyMassSource { .health }
}
