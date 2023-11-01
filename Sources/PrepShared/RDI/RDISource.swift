import Foundation

public struct RDISource: Identifiable, Codable, Hashable, Equatable {
    public let id: UUID
    public var createdAt: Date
    public var updatedAt: Date
    public var isTrashed: Bool
    
    public var abbreviation: String?
    public var name: String
    public var detail: String?
    public var url: String?
    
    public init(
        id: UUID = UUID(),
        createdAt: Date = Date(),
        updatedAt: Date = Date(),
        isTrashed: Bool = false,
        abbreviation: String? = nil,
        name: String,
        detail: String? = nil,
        url: String? = nil
    ) {
        self.id = id
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.isTrashed = isTrashed
        self.abbreviation = abbreviation
        self.name = name
        self.detail = detail
        self.url = url
    }
    
    public init(from entity: RDISourceEntity) {
        self.init(
            id: entity.id!,
            createdAt: entity.createdAt!,
            updatedAt: entity.updatedAt!,
            isTrashed: entity.isTrashed,
            abbreviation: entity.abbreviation,
            name: entity.name!,
            detail: entity.detail,
            url: entity.url
        )
    }
}

import CloudKit

public extension RDISource {
    init(_ record: CKRecord) {
        self.init(
            id: record.id!,
            createdAt: record.createdAt!,
            updatedAt: record.updatedAt!,
            isTrashed: record.isTrashed!,
            abbreviation: record.abbreviation,
            name: record.name!,
            detail: record.detail,
            url: record.url
        )
    }
}

extension RDISource: Pickable {
    public var pickedTitle: String { abbreviation ?? name }
    public var menuTitle: String { name }
    public static var `default`: RDISource { .init(name: "Unnamed Source") }
    public static var allCases: [RDISource] { [] }
}
