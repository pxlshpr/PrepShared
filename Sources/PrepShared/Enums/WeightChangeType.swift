import Foundation

public enum WeightChangeType: Int, Hashable, Codable, CaseIterable, Identifiable {
    case weights = 1
    case manual
    
    public var id: Int { rawValue }
}

public extension WeightChangeType {
    var name: String {
        switch self {
        case .manual: "Manual"
        case .weights: "Weights"
        }
    }
}
