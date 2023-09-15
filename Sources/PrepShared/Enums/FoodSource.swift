import Foundation
import SwiftUI

public enum FoodSource: CaseIterable {
    case dataset
    case `private`
    case `public`
}

public extension FoodSource {
    var name: String {
        switch self {
        case .dataset:  "Official"
        case .private:  "My"
        case .public:   "Verified"
        }
    }
    
    var systemImage: String {
        switch self {
        case .dataset:  "building.columns.fill"
        case .private:  "person.fill"
        case .public:   "checkmark.seal.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .dataset:  .brown
        case .private:  .blue
        case .public:   .green
        }
    }
}

extension FoodSource {
    var heuristics: [FoodSortHeuristic] {
        [
            .lastUsedAt, 
            .tokenRank,
            .isRaw,
//            .numberOfMatchedWords,
//            .distance,
//            .length,
//            .ratio
        ]
    }
}

public extension Food {
    var source: FoodSource {
        if self.dataset != nil {
            return .dataset
        }
        if self.isOwnedByMe {
            return .private
        }
        return .public
    }
}
