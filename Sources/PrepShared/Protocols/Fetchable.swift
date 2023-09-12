import Foundation
import CoreData

public protocol Fetchable {
    associatedtype FetchableType: NSManagedObject = Self
    static var entityName : String { get }
    
    static func countAll(in context: NSManagedObjectContext) -> Int
    static func entity(with id: UUID, in context: NSManagedObjectContext) -> FetchableType?
    
    static func entities(
        predicate: NSPredicate?,
        sortDescriptors: [NSSortDescriptor]?,
        fetchLimit: Int?,
        fetchOffset: Int?,
        in: NSManagedObjectContext
    ) -> [FetchableType]
}
