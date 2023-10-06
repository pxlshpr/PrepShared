import Foundation

public struct Plan: Identifiable, Hashable, Codable {
    
    public var id: UUID
    public var name: String
    public var isDisabled: Bool
    public var goals: [Goal] = []
    
    public init(
        id: UUID = UUID(),
        name: String,
        isDisabled: Bool = false,
        goals: [Goal] = []
    ) {
        self.id = id
        self.name = name
        self.isDisabled = isDisabled
        self.goals = goals
    }
}
