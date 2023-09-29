import Foundation

public struct Plan: Identifiable, Hashable, Codable {
    
    public let id: UUID
    public var name: String
    public var goals: [Goal] = []
    
    public init(
        id: UUID = UUID(),
        name: String,
        goals: [Goal] = []
    ) {
        self.id = id
        self.name = name
        self.goals = goals
    }
}
