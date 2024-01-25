import Foundation

public struct RDIFields: Hashable, Equatable {

    public var micro: Micro
    public var unit: NutrientUnit
    public var type: RDIType
    public var url: String
    public var formValues: [RDIFormValue]
    public var source: RDISource?
    
    public init(
        micro: Micro,
        unit: NutrientUnit? = nil,
        type: RDIType = .default,
        url: String = "",
        formValues: [RDIFormValue] = [],
        source: RDISource? = nil
    ) {
        self.micro = micro
        self.unit = unit ?? .mg
        self.type = type
        self.url = url
        self.formValues = formValues
        self.source = source
    }
}

public extension RDIFields {
    
    var canBeSaved: Bool {
        source != nil
        && !url.isEmpty
        && !formValues.isEmpty
        && formValues.allSatisfy({ $0.isValid })
    }
    
    mutating func fill(with rdi: RDI) {
        micro = rdi.micro
        unit = rdi.unit
        type = rdi.type
        url = rdi.url
        formValues = rdi.values.map { .init(value: $0) }
        source = rdi.source
    }
}
