import Foundation
import SwiftUI

public enum FoodSource: CaseIterable {
    case dataset
    case `private`
    case `public`
}

public extension FoodSource {
    var description: String {
        switch self {
        case .dataset:  "Official Foods"
        case .private:  "My Foods"
        case .public:   "Verified Foods"
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
//            .isRaw,
            .numberOfMatchedWords,
//            .distance,
//            .length,
//            .ratio
        ]
    }
}

public extension Food {
    var foodSource: FoodSource {
        if self.dataset != nil {
            return .dataset
        }
        if self.isOwnedByMe {
            return .private
        }
        return .public
    }
}
