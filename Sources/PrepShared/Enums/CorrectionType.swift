import Foundation

public enum CorrectionType: Int, Codable, CaseIterable {
    case add = 1
    case subtract
    case multiply
    case divide
}
