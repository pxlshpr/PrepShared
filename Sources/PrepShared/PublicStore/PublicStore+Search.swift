import Foundation

extension PublicStore {
    public static func searchFoods(
        source: FoodSource,
        entityType: any Searchable.Type,
        with text: String?,
        page: Int
    ) async throws -> [Food] {
        
        guard let text, !text.isEmpty else { return [] }
        
        let matchedWords = await PublicStore.findWords(in: text)
        try Task.checkCancellation()
        
        let entities = entityType.entities(for: matchedWords, page: page)
        let foods = entities.map { $0.asFood }
        let sorted = foods.sorted(by: {
            Food.areInIncreasingOrder($0, $1,
                                      for: text,
                                      wordResults: matchedWords,
                                      source: source
            )
        })

        return sorted
    }
}
