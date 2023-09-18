import Foundation
import CoreData

public protocol Searchable: Entity {
    static func entities(for wordResults: [FindWordResult], page: Int, in context: NSManagedObjectContext) -> [Self]
    static var sortDescriptors: [NSSortDescriptor] { get }
    static var store: any Store.Type { get }
    static var searchSource: FoodSource { get }
    
    static var predicate: NSPredicate? { get }
    var asFood: Food { get }
    
    /// Fields used in the predicates
    var name: String? { get set }
    var detail: String? { get set }
    var brand: String? { get set }
    var lastUsedAt: Date? { get set }
    var isTrashed: Bool { get set }
    var searchTokensString: String? { get set }
}


public extension Searchable {
    func contains(wordID: UUID) -> Bool {
        searchTokens.contains(where: { $0.wordID == wordID })
    }
    
    func contains(wordID: UUID, withRank rank: SearchRank) -> Bool {
        searchTokens.contains(where: {
            $0.wordID == wordID
            && $0.rank == rank
        })
    }

    func removeSearchToken(wordID: UUID) {
        searchTokens.removeAll(where: { $0.wordID == wordID })
    }
    
    func setSearchToken(wordID: UUID, rank: SearchRank) {
        removeSearchToken(wordID: wordID)
        searchTokens.append(.init(wordID: wordID, rank: rank))
    }
    
    static func replaceWordID(_ old: UUID, with new: UUID, in context: NSManagedObjectContext) {
        entities(
            in: context,
            predicate: NSPredicate(format: "searchTokensString CONTAINS %@", old.uuidString)
        ).forEach { entity in
            guard let entity = entity as? Self else { return }
            entity.replaceWordID(old, with: new)
        }
    }
    
    func replaceWordID(_ old: UUID, with new: UUID) {
        guard let index = searchTokens.firstIndex(where: { $0.wordID == old }) else {
            return
        }
        searchTokens[index].wordID = new
    }
    
    var searchTokens: [FlattenedSearchToken] {
        get {
            guard let searchTokensString else { return [] }
            return searchTokensString.searchTokens
        }
        set {
            self.searchTokensString = newValue.asString
        }
    }
}

extension Searchable {
    public static var predicate: NSPredicate? { nil }

    public static var sortDescriptors: [NSSortDescriptor] {
        [
            NSSortDescriptor(key: "lastUsedAt", ascending: false),
            NSSortDescriptor(key: "name", ascending: true)
        ]
    }
    
    public static func entities(
        for wordResults: [FindWordResult],
        page: Int,
        in context: NSManagedObjectContext
    ) -> [Self] {
        Self.entities(
            in: context,
            predicate: predicate(for: wordResults),
            sortDescriptors: sortDescriptors,
            fetchLimit: FoodsPageSize,
            fetchOffset: (page - 1) * FoodsPageSize
        ) as! [Self]
    }
}

public extension Searchable {
    static func searchFoods(with text: String?, page: Int) async throws -> [Food] {
        
        guard let text, !text.isEmpty else { return [] }
        
        let results = try await PublicStore.findWords(in: text)
        try Task.checkCancellation()
        
        var foods: [Food] = []
        try await PublicStore.performInBackground { context in
            let entities = entities(for: results, page: page, in: context)
            foods = entities.map { $0.asFood }
        }
        return foods
            .sorted(by: {
                Food.areInIncreasingOrder($0, $1,
                                          for: text,
                                          wordResults: results,
                                          source: searchSource
                )
            })
    }

    
}

extension Searchable {
    
    static func metadataPredicate(for text: String) -> NSPredicate {
        let name = NSPredicate(format: "name CONTAINS[cd] %@", text)
        let detail = NSPredicate(format: "detail CONTAINS[cd] %@", text)
        let brand = NSPredicate(format: "brand CONTAINS[cd] %@", text)
        return NSCompoundPredicate(orPredicateWithSubpredicates: [name, detail, brand])
    }

    static func wordPredicate(for word: SearchWord) -> NSPredicate {
        let id = NSPredicate(format: "searchTokensString CONTAINS[cd] %@", word.id.uuidString)
        let singular = metadataPredicate(for: word.singular)
        
        var subpredicates = [id, singular]
        for spelling in word.spellings {
            subpredicates.append(metadataPredicate(for: spelling))
        }
        return NSCompoundPredicate(orPredicateWithSubpredicates: subpredicates)
    }

    static func wordsPredicate(for wordResults: [FindWordResult]) -> NSPredicate? {
        var predicates: [NSPredicate] = []
        for word in wordResults.allWords {
            predicates.append(wordPredicate(for: word))
        }
        guard !predicates.isEmpty else { return nil }
        return NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
    }

    static func unrecognizedWordsPredicate(for wordResults: [FindWordResult]) -> NSPredicate? {
        var subpredicates: [NSPredicate] = []
        for unrecognizedWord in wordResults.unrecognizedWords {
            subpredicates.append(metadataPredicate(for: unrecognizedWord))
        }
        
        guard !subpredicates.isEmpty else { return nil }
        return NSCompoundPredicate(andPredicateWithSubpredicates: subpredicates)
    }
    
    static func matchPredicate(for results: [FindWordResult]) -> NSPredicate {
        NSCompoundPredicate(andPredicateWithSubpredicates: [
            unrecognizedWordsPredicate(for: results),
            wordsPredicate(for: results)
        ].compactMap({$0}))
    }
    
    static var notSoftDeletedPredicate: NSPredicate {
        NSPredicate(format: "isTrashed == NO")
    }
    
    static func basePredicate(for wordResults: [FindWordResult]) -> NSPredicate {
        NSCompoundPredicate(andPredicateWithSubpredicates: [
            matchPredicate(for: wordResults),
            notSoftDeletedPredicate
        ])
    }
    
    static func predicate(for wordResults: [FindWordResult]) -> NSPredicate {
        let basePredicate = basePredicate(for: wordResults)
        if let predicate {
            return NSCompoundPredicate(andPredicateWithSubpredicates: [basePredicate, predicate])
        } else {
            return basePredicate
        }
    }
}
