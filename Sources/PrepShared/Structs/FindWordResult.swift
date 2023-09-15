import Foundation

public struct FindWordResult {
    
    /// Multiple `SearchWord`s that have matched the word. A match is when the main `singular`
    /// spelling or any of the alternative spellings match the word.
    public let words: [SearchWord]?

    /// When no `SearchWord` is found, the original word is placed here so that it can still be used for
    /// lower priority searches.
    public let string: String?
    
    public init(words: [SearchWord]?, string: String?) {
        self.words = words
        self.string = string
    }
}

public extension Array where Element == FindWordResult {
    var unrecognizedWords: [String] {
        self.compactMap { $0.string }
    }
    
    var allWordArrays: [[SearchWord]] {
        self.compactMap { $0.words }
    }
    
    var allWords: [SearchWord] {
        allWordArrays.reduce([]) { partialResult, array in
            partialResult + array
        }
    }
    
    var allStrings: [String] {
        allWords
            .map { [$0.singular] + $0.spellings }
            .reduce([]) { $0 + $1 }
        + unrecognizedWords
    }

    var allWordIDs: [UUID] {
        self.compactMap { $0.words }
            .reduce([]) { wordIDs, array in
                wordIDs + array.reduce([], { partialResult, word in
                    partialResult + [word.id]
                })
            }
    }
    
    var wordIDArrays: [[UUID]] {
        self.compactMap {
            guard let words = $0.words else { return nil }
            return words.map { $0.id }
        }
    }
}
