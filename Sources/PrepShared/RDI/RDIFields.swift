import Foundation

public struct RDIFields: Hashable, Equatable {

    public var micro: Micro?
    public var unit: NutrientUnit?
    public var type: RDIType
    public var url: String?
    public var values: [RDIValue]
    public var source: RDISource?
    
    public init(
        micro: Micro? = nil,
        unit: NutrientUnit? = nil,
        type: RDIType = .default,
        url: String? = nil,
        values: [RDIValue] = [],
        source: RDISource? = nil
    ) {
        self.micro = micro
        self.unit = unit
        self.type = type
        self.url = url
        self.values = values
        self.source = source
    }
}

public extension RDIFields {
    
    var canBeSaved: Bool {
        micro != nil
        && unit != nil
        && !values.isEmpty
    }
    
    mutating func fill(with rdi: RDI) {
        micro = rdi.micro
        unit = rdi.unit
        type = rdi.type
        url = rdi.url
        values = rdi.values
        source = rdi.source
    }
}
