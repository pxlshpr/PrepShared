import CoreData

public protocol Store {
    static var shared: Self { get }
    static var mainContext: NSManagedObjectContext { get }
    static func newBackgroundContext() -> NSManagedObjectContext
}

extension Store {
    
    public static func performInBackground(
        _ block: @escaping (NSManagedObjectContext) throws -> ()
    ) async throws {
        let context = newBackgroundContext()
        try await shared.perform(in: context) {
            try block(context)
        }
    }

    public static func perform(
        in context: NSManagedObjectContext,
        _ block: @escaping () throws -> ()
    ) async throws {
        try await shared.perform(in: context, block)
    }

    /// Performs the `block` of code in the provided `context` and then merges the changes with the `viewContext` on the main thread
    func perform(
        in context: NSManagedObjectContext,
        _ block: @escaping () throws -> ()
    ) async throws {
        try await context.performAndMergeWith(Self.mainContext, block)
    }
    
    func fetch(
        in context: NSManagedObjectContext,
        _ block: @escaping () throws -> ()
    ) async throws {
        try await fetchInBackgroundContext(
            context,
            mainContext: Self.mainContext,
            performBlock: block
        )
    }

}
