import Foundation

public enum NutrientsFilter: Int, Codable, CaseIterable, Identifiable {
    case goals
    case all
}

public extension NutrientsFilter {
    var name: String {
        switch self {
        case .goals:    "Plan Nutrients"
        case .all:      "All Nutrients"
        }
    }
    
    var systemImage: String {
        switch self {
        case .goals:    "list.bullet.clipboard"
        case .all:      "chart.bar.doc.horizontal"
        }
    }
    
    var id: Int { rawValue }
}
