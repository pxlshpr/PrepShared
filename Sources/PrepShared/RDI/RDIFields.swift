import Foundation

public struct RDIFields: Hashable, Equatable {

    public var micro: Micro? {
        didSet {
            unit = micro?.defaultUnit ?? .mg
        }
    }
    
    public var unit: NutrientUnit
    public var type: RDIType
    public var url: String
    public var values: [RDIValue]
    public var source: RDISource?
    
    public init(
        micro: Micro? = nil,
        unit: NutrientUnit? = nil,
        type: RDIType = .default,
        url: String = "",
        values: [RDIValue] = [],
        source: RDISource? = nil
    ) {
        self.micro = micro
        self.unit = unit ?? .mg
        self.type = type
        self.url = url
        self.values = values
        self.source = source
    }
}

public extension RDIFields {
    
    var canBeSaved: Bool {
        micro != nil
        && !values.isEmpty
        && values.hasAllParamCombos
    }
    
    mutating func fill(with rdi: RDI) {
        micro = rdi.micro
        unit = rdi.unit
        type = rdi.type
        url = rdi.url ?? ""
        values = rdi.values
        source = rdi.source
    }
}
