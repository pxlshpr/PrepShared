import Foundation

public struct RDISourceFields: Hashable, Equatable {
    public var abbreviation: String
    public var name: String
    public var detail: String
    public var url: String
    
    public init(
        abbreviation: String = "",
        name: String = "",
        detail: String = "",
        url: String = ""
    ) {
        self.abbreviation = abbreviation
        self.name = name
        self.detail = detail
        self.url = url
    }
}

public extension RDISourceFields {
    
    var canBeSaved: Bool {
        !name.isEmpty
    }
    
    mutating func fill(with rdiSource: RDISource) {
        abbreviation = rdiSource.abbreviation ?? ""
        name = rdiSource.name
        detail = rdiSource.detail ?? ""
        url = rdiSource.url ?? ""
    }
}
