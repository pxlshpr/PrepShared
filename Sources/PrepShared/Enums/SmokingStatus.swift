import Foundation

public enum SmokingStatus: Int16, Codable, CaseIterable {
    case nonSmoker = 1
    case smoker
    case notSet
}
