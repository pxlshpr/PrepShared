import Foundation

public enum ActivityLevel: Int, Codable, Hashable, CaseIterable {
    case sedentary = 1
    case lightlyActive
    case moderatelyActive
    case active
    case veryActive
}
