import Foundation

public struct DailyValue: Codable, Hashable {
    public let type: DailyValueType
    public let rdi: RDI?
    public let customValue: CustomValue?
    
    public struct CustomValue: Codable, Hashable {
        public let bound: Bound
        public let unit: NutrientUnit
        
        public init(bound: Bound, unit: NutrientUnit) {
            self.bound = bound
            self.unit = unit
        }
    }
    
    public init(type: DailyValueType, rdi: RDI?, customValue: CustomValue?) {
        self.type = type
        self.rdi = rdi
        self.customValue = customValue
    }
}
