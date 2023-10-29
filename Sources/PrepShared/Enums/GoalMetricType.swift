import Foundation

public enum GoalMetricType: Int, Codable, CaseIterable, Identifiable {
    case consumed
    case remaining
    case target
}

public extension GoalMetricType {
    
    var name: String {
        switch self {
        case .consumed:     "Consumed"
        case .remaining:    "Remaining"
        case .target:       "Target"
        }
    }
    
    var id: Int { rawValue }
}

extension GoalMetricType: Pickable {
    public var pickedTitle: String { name }
    public var menuTitle: String { name }
    public static var `default`: GoalMetricType { .consumed }
}
