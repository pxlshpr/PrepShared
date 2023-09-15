import Foundation

enum FoodSortHeuristic {
    case tokenRank
    case isRaw
    case numberOfMatchedWords
    case distance
    case length
    case ratio
    
    var function: ((FoodSortParams) -> Bool?) {
        switch self {
        case .tokenRank:            areInIncreasingOrderUsingTokenRank
        case .isRaw:                areInIncreasingOrderUsingIsRaw
        case .numberOfMatchedWords: areInIncreasingOrderUsingNumberOfMatchedWords
        case .distance:             areInIncreasingOrderUsingDistance
        case .length:               areInIncreasingOrderUsingLength
        case .ratio:                areInIncreasingOrderUsingRatio
        }
    }
}
