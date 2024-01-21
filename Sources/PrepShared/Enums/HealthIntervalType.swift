import Foundation

public enum HealthIntervalType: Int16, Codable, CaseIterable {
    case average = 1
    case sameDay
    case previousDay
}
