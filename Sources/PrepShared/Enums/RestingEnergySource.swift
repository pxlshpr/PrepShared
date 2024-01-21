import Foundation

public enum RestingEnergySource: Int, Codable, CaseIterable {
    case equation = 1
    case healthKit
    case manual
}
