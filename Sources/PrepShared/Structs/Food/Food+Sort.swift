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
    
    var isRaw: Bool {
        detail?.lowercased() == "raw" || detail?.lowercased().contains(", raw") == true
    }

    func numberOfWordMatches(of params: FoodSortParams) -> Int {
        
        var count = 0
        var unmatchedWords: [SearchWord] = []
        
        /// [ ] First go through all `params.wordResults`
        /// [ ] Counting how many are present in `searchTokens`
        /// [ ] While removing them from a separate array we keep
        for wordArray in params.wordResults.allWordArrays {
            if wordArray.contains(where: { word in
                searchTokens.contains(where: { $0.wordID == word.id })
            }) {
                count += 1
            } else {
                unmatchedWords.append(contentsOf: wordArray)
            }
        }

        /// [ ] Now with the remaning words, with all their spellings, and the unrecognized words in an array
        var strings = unmatchedWords
            .map { $0.allStrings }
            .reduce([]) { $0 + $1 }
        + params.wordResults.unrecognizedWords

        /// [ ] Go through all the words in each of name, detail, brand
        /// [ ] Count each one that has a match in the array we're keeping
        /// [ ] At the end return this count
        for text in [name, detail, brand].compactMap({$0}) {
            for textWord in text.searchWords {
                if strings.contains(textWord) {
                    count += 1
                    strings.removeAll(where: { $0 == textWord })
                }
            }
        }
        
        return count
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


func areInIncreasingOrderUsingIsRaw(_ params: FoodSortParams) -> Bool? {
    let isRaw0 = params.food0.isRaw
    let isRaw1 = params.food1.isRaw
    guard isRaw0 != isRaw1 else { return nil }

    /// *Prioritise foods that are raw*
    return isRaw0
}

func areInIncreasingOrderUsingLastUsedAt(_ params: FoodSortParams) -> Bool? {
    let date0 = params.food0.lastUsedAt
    let date1 = params.food1.lastUsedAt
    
    switch (date0, date1) {
    case (.some(let date0), .some(let date1)):
        /// *Prioritise foods that have a more recent lastUsedAt date*
        return date0 > date1

    /// *Prioritise foods that have a lastUsedAt date when comparing with those that do not*
    case (.some, .none):
        return true
    case (.none, .some):
        return false

    case (.none, .none):
        /// *Discard this comparison when never food has a lastUsedAt date*
        return nil
    }
}

func areInIncreasingOrderUsingTokenRank(_ params: FoodSortParams) -> Bool? {
    let rank0 = params.food0.tokenRank(for: params.wordResults)
    let rank1 = params.food1.tokenRank(for: params.wordResults)
    guard rank0 != rank1 else { return nil }

    /// *Prioritise foods that have a higher token rank*
    return rank0 > rank1
}

func areInIncreasingOrderUsingNumberOfMatchedWords(_ params: FoodSortParams) -> Bool? {
    let count0 = params.food0.numberOfWordMatches(of: params)
    let count1 = params.food1.numberOfWordMatches(of: params)
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
