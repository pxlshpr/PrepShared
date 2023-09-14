import Foundation

public extension Food {
    
    static func areInIncreasingOrder(
        _ lhs: Food,
        _ rhs: Food,
        for text: String,
        wordResults: [FindWordResult],
        source: FoodSource
    ) -> Bool {
        
        let params = FoodSortParams(
            food0: lhs,
            food1: rhs,
            text: text,
            wordResults: wordResults
        )
        
        for heuristic in source.heuristics {
            if let areIncreasing = heuristic.function(params) {
                return areIncreasing
            }
        }
        
        /// If all heuristics were equal, return an arbitrary `true` for now
        return true
    }
}

public extension Food {
    func contains(_ word: String) -> Bool {
        if name.searchWords.contains(word) { return true }
        if let detail, detail.searchWords.contains(word) { return true }
        if let brand, brand.searchWords.contains(word) { return true }
        return false
    }
}

extension Food {
    
    var totalCount: Int {
        var count = name.count
        count += detail?.count ?? 0
        count += brand?.count ?? 0
        return count
    }
    
    func tokenRank(for results: [FindWordResult]) -> Int {
        var total = 0
        /// For each array of matched `SearchWord.id`'s (one array per word of the search text), we pick the
        /// highest rank and add that to the total (so that we're not adding all the ranks of all the matched search words which
        /// would skew the results).
        for wordIDArray in results.wordIDArrays {
            let ranks: [Int] = wordIDArray.compactMap { wordID in
                guard let token = searchTokens.first(where: { $0.wordID == wordID }) else {
                    return nil
                }
                return token.rank.rawValue
            }
            let max = ranks.sorted().last ?? 0
            total += max
        }
        return total
    }

    func ratioOfSearchText(_ text: String) -> Double {
        let text = text.lowercased()
        
        var max: Double = 0
        if let ratio = name.lowercased().ratio(of: text) {
            max = ratio
        }
        
        if let detail,
           let ratio = detail.lowercased().ratio(of: text),
           ratio > max {
            max = ratio
        }
        if let brand,
           let ratio = brand.lowercased().ratio(of: brand),
           ratio > max {
            max = ratio
        }
        
        return max
    }
    
//    var isRaw: Bool {
//        detail?.lowercased() == "raw" || detail?.lowercased().contains(", raw") == true
//    }

    func numberOfWordMatches(of text: String) -> Int {
        //TODO: Count how many tokens of text are matched (all lowercased).
        /// [ ] Check search tokens (each has individual words) and each word in name, detail and brand
        /// [ ] So, "banana chips" should match 2 with food named "banana chips", and 1 with food named "banana"
        return 0
    }
    
    func distanceOfSearchText(_ text: String) -> Int {
        
        //TODO:
        let text = text.lowercased()
        
//        logger.debug("Getting distance within \(self.description, privacy: .public)")
        var distance: Int = Int.max
        if let index = name.lowercased().index(of: text) {
            distance = index
        }
        
        if let detail,
           let index = detail.lowercased().index(of: text),
           index < distance {
            distance = index + 100
        }
        if let brand,
           let index = brand.lowercased().index(of: brand),
           index < distance {
            distance = index + 200
        }
        
//        let logger = Logger(subsystem: "Search", category: "Text Distance")
//        logger.debug("Distance of \(text, privacy: .public) within \(self.description, privacy: .public) = \(distance)")
        
        return distance
    }
}


//func areInIncreasingOrderUsingIsRaw(_ params: FoodSortParams) -> Bool? {
//    let isRaw0 = params.food0.isRaw
//    let isRaw1 = params.food1.isRaw
//    guard isRaw0 != isRaw1 else { return nil }
//
//    /// *Prioritise foods that are raw*
//    return isRaw0
//}

func areInIncreasingOrderUsingTokenRank(_ params: FoodSortParams) -> Bool? {
    let rank0 = params.food0.tokenRank(for: params.wordResults)
    let rank1 = params.food1.tokenRank(for: params.wordResults)
    guard rank0 != rank1 else { return nil }

    /// *Prioritise foods that have a higher token rank*
    return rank0 > rank1
}

func areInIncreasingOrderUsingNumberOfMatchedWords(_ params: FoodSortParams) -> Bool? {
    let count0 = params.food0.numberOfWordMatches(of: params.text)
    let count1 = params.food1.numberOfWordMatches(of: params.text)
    guard count0 != count1 else { return nil }

    /// *Prioritise foods that have more token matches*
    return count0 > count1
}

func areInIncreasingOrderUsingDistance(_ params: FoodSortParams) -> Bool? {
    let distance0 = params.food0.distanceOfSearchText(params.text)
    let distance1 = params.food1.distanceOfSearchText(params.text)
    guard distance0 != distance1 else { return nil }

    /// *Prioritise foods that the search term closer to the start of the matching field*
    return distance0 < distance1
}

func areInIncreasingOrderUsingLength(_ params: FoodSortParams) -> Bool? {
    /// Check the total length of the name, brand and detail fields
    let count0 = params.food0.totalCount
    let count1 = params.food1.totalCount
    guard count0 != count1 else { return nil }

    /// *Prioritise the shorter results*
    return count0 < count1
}

func areInIncreasingOrderUsingRatio(_ params: FoodSortParams) -> Bool? {
    /// Check the ratio of the text within the relevant field's text
    let ratio0 = params.food0.ratioOfSearchText(params.text)
    let ratio1 = params.food1.ratioOfSearchText(params.text)
    
    /// *Prioritise foods that have a higher ratio of the search term within the matching field*
    guard ratio0 != ratio1 else { return nil}
    return ratio0 > ratio1
}
