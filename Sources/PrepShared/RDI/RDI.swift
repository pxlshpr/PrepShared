import Foundation

public struct RDI: Codable, Hashable, Equatable {
    
    public let id: UUID
    public var createdAt: Date
    public var updatedAt: Date
    public var isTrashed: Bool
    
    public let micro: Micro
    public let unit: NutrientUnit
    public let type: RDIType
    
    public let values: [RDIValue]

    public let source: RDISource
    public let url: String

    public init(
        id: UUID = UUID(),
        createdAt: Date = Date(),
        updatedAt: Date = Date(),
        isTrashed: Bool = false,
        micro: Micro,
        unit: NutrientUnit,
        type: RDIType,
        values: [RDIValue],
        source: RDISource,
        url: String
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
    
    public init(from entity: RDIEntity) {
        self.init(
            id: entity.id!,
            createdAt: entity.createdAt!,
            updatedAt: entity.updatedAt!,
            isTrashed: entity.isTrashed,
            micro: entity.micro,
            unit: entity.unit,
            type: entity.type,
            values: entity.values,
            source: entity.source!,
            url: entity.url!
        )
    }
}
