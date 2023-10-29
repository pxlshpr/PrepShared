import Foundation

public enum MacrosBarType: Int, Codable, CaseIterable, Identifiable {
    case foodItem
    case meal
    case none
}

public extension MacrosBarType {
    
    var id: Int { rawValue }

    var name: String {
        switch self {
        case .foodItem: "Foods"
        case .meal:     "Meals"
        case .none:     "None"
        }
    }
}

extension MacrosBarType: Pickable {
    public var pickedTitle: String { name }
    public var menuTitle: String { name }
    public static var `default`: MacrosBarType { .foodItem }
}
