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
            abbreviation: entity.abbreviation?.isEmpty == true ? nil : entity.abbreviation,
            name: entity.name!,
            detail: entity.detail?.isEmpty == true ? nil : entity.detail,
            url: entity.url?.isEmpty == true ? nil : entity.url
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
            abbreviation: record.abbreviation?.isEmpty == true ? nil : record.abbreviation,
            name: record.name!,
            detail: record.detail?.isEmpty == true ? nil : record.detail,
            url: record.url?.isEmpty == true ? nil : record.url
        )
    }
}
