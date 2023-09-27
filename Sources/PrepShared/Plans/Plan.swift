import Foundation

public struct Plan: Identifiable, Hashable, Codable {
    
    public let id: UUID
    public var name: String
    public var emoji: String
    public var goals: [Goal] = []
    
    public init(
        id: UUID = UUID(),
        name: String,
        emoji: String,
        goals: [Goal] = []
    ) {
        self.id = id
        self.name = name
        self.emoji = emoji
        self.goals = goals
    }
}
