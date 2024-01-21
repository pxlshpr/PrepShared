import Foundation

public enum DietaryEnergyPointSource: Int, Codable, CaseIterable, Identifiable {
    case log = 1
    case healthKit
    case fasted
    case manual
    case notCounted
    
    public var id: Int {
        rawValue
    }
}
