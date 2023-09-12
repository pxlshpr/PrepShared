import Foundation
import CoreData

public protocol Fetchable {
    associatedtype FetchableType: NSManagedObject = Self
    static var entityName : String { get }
    
    static func countAll(in context: NSManagedObjectContext) -> Int
    static func entity(in context: NSManagedObjectContext, with id: UUID) -> FetchableType?
    
    static func entities(
        in: NSManagedObjectContext,
        predicate: NSPredicate?,
        sortDescriptors: [NSSortDescriptor]?,
        fetchLimit: Int?,
        fetchOffset: Int?
    ) -> [FetchableType]
}
