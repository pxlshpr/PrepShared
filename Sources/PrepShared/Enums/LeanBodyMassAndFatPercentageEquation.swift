import Foundation

public enum LeanBodyMassAndFatPercentageEquation: Int, Identifiable, Codable, CaseIterable {
    case boer = 1
    case james
    case hume
    
    case bmi
    case cunBAE
    
    public var id: Int {
        rawValue
    }
}
