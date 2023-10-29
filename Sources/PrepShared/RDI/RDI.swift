import Foundation

public struct RDI: Codable, Hashable, Equatable {
    
    public let id: UUID
    public var createdAt: Date
    public var updatedAt: Date
    public var isTrashed: Bool
    
    public let micro: Micro
    public let unit: NutrientUnit
    public let type: RDIType
    public let url: String?
    public let values: [RDIValue]

    public let source: RDISource?

    public init(
        id: UUID = UUID(),
        createdAt: Date = Date(),
        updatedAt: Date = Date(),
        isTrashed: Bool = false,
        micro: Micro,
        unit: NutrientUnit,
        url: String? = nil,
        type: RDIType,
        values: [RDIValue],
        source: RDISource? = nil
    ) {
        self.id = id
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.isTrashed = isTrashed
        self.micro = micro
        self.unit = unit
        self.values = values
        self.type = type
        self.url = url
        self.source = source
    }
}
