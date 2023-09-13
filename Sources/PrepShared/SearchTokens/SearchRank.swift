import Foundation

public enum SearchRank: Int, Codable, CaseIterable {
    case none       = 0
    case quinary    = 1
    case quaternary = 2
    case tertiary   = 3
    case secondary  = 4
    case primary    = 5
}

public extension SearchRank {
    
    static var displayTitle: String {
        /// Use this as its more user-friendly and understandable than "Search Rank"
        "Association"
    }
    
    static var allPriorities: [SearchRank] {
        [.quinary, .quaternary, .tertiary, .secondary, .primary]
    }
    
    var menuDescription: String {
        switch self {
        case .none:         "Remove"
        case .quinary:      "Quinary"
        case .quaternary:   "Quaternary"
        case .tertiary:     "Tertiary"
        case .secondary:    "Secondary"
        case .primary:      "Primary"
        }
    }
    
    var description: String {
        switch self {
        case .none:
            "Not Included"
        default:
            "\(menuDescription) Association"
        }
    }
    
    var systemImage: String {
        switch self {
        case .none: "minus.circle"
        default:    "\(self.rawValue).square"
        }
    }
}

import SwiftUI

public extension SearchRank {
    
    var exampleText: Text {
        switch self {
        case .quinary:
            Text("e.g. \"Guavas, Strawberry, Raw\" for **strawberry**")
        case .quaternary:
            Text("e.g. \"Strawberry Sundae, McDonald's\" for **strawberry**")
        case .tertiary:
            Text("e.g. \"Toppings, Strawberry\" for **strawberry**")
        case .secondary:
            Text("e.g. \"Strawberries, Frozen\" for **strawberry**")
        case .primary:
            Text("e.g. \"Strawberries, Raw\" for **strawberry**")
        default:
            Text("")
        }
    }
}
