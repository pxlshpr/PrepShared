import Foundation
import CoreData

public protocol SearchableFoodEntity: Entity {
    static func entities(for wordResults: [FindWordResult], page: Int) -> [Self]
    static var sortDescriptors: [NSSortDescriptor] { get }
    static var store: any Store.Type { get }
    
    static var predicate: NSPredicate? { get }
    var asFood: Food { get }
    
    var name: String? { get }
    var detail: String? { get }
    var brand: String? { get }
    var isTrashed: Bool { get }
    var searchTokensString: String? { get }
}

extension SearchableFoodEntity {
    
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
        return NSCompoundPredicate(orPredicateWithSubpredicates: predicates)
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
        NSCompoundPredicate(orPredicateWithSubpredicates: [
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

extension SearchableFoodEntity {
    public static var predicate: NSPredicate? { nil }

    public static var sortDescriptors: [NSSortDescriptor] {
        [
//            NSSortDescriptor(key: "lastUsedAt", ascending: false),
            NSSortDescriptor(key: "name", ascending: true)
        ]
    }
    
    public static func entities(for wordResults: [FindWordResult], page: Int) -> [Self] {
        Self.entities(
            in: store.newBackgroundContext(),
            predicate: predicate(for: wordResults),
            sortDescriptors: sortDescriptors,
            fetchLimit: FoodsPageSize,
            fetchOffset: (page - 1) * FoodsPageSize
        ) as! [Self]
    }
}

