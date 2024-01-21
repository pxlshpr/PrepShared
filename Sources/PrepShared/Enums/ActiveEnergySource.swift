import Foundation

public enum ActiveEnergySource: Int, Codable, CaseIterable {
    case activityLevel = 1
    case healthKit
    case manual
}
