import Foundation

extension String {
    func index(of string: String) -> Int? {
        guard self.contains(string) else { return nil }
        for (index, _) in self.enumerated() {
            var found = true
            for (offset, char2) in string.enumerated() {
                if self[self.index(self.startIndex, offsetBy: index + offset)] != char2 {
                    found = false
                    break
                }
            }
            if found {
                return index
            }
        }
        return nil
    }
    
    func ratio(of string: String) -> Double? {
        guard self.contains(string) else { return nil }
        return Double(string.count) / Double(count)
    }
}

public extension String {
    var detectedValuesForScanner: [FoodLabelValue] {
        FoodLabelValue.detect(in: self, forScanner: true)
    }
    
    var detectedValues: [FoodLabelValue] {
        FoodLabelValue.detect(in: self, forScanner: false)
    }
}

public extension String {
    
    func sanitizedSearchWord() -> String {
        let invalidCharacters = CharacterSet
            .whitespacesAndNewlines
            .union(.controlCharacters)
            .union(.illegalCharacters)
            .union(.decimalDigits)
            .union(.punctuationCharacters)
            .union(.symbols)
        return self
            .lowercased()
            .components(separatedBy: invalidCharacters)
            .joined()
    }
    
    var searchWords: [String] {
//        self
//            .replacingOccurrences(of: ",", with: " ")
//            .replacingOccurrences(of: ".", with: " ")
//            .components(separatedBy: " ")
//            .map { $0.replacingOccurrences(of: " ", with: "") } /// handles double, triple, etc whitespaces
//            .compactMap { $0.isEmpty ? nil : $0 }
        
        self
            .components(separatedBy: " ")
            .map { $0.sanitizedSearchWord() }
            .compactMap { $0.isEmpty ? nil : $0 }
    }
}
