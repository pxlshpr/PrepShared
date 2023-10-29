import Foundation

public enum DailyValueType: Int, CaseIterable, Codable {
    case rdi
    case custom
}

public extension DailyValueType {
    var name: String {
        switch self {
        case .rdi:      "RDI"
        case .custom:   "Custom"
        }
    }
}

extension DailyValueType: Pickable {
    public var pickedTitle: String { name }
    public var menuTitle: String { name }
    public static var `default`: DailyValueType {
        .rdi
    }
}
