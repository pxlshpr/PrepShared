import Foundation

public struct RDIFormValue: Hashable, Codable, Equatable {
    public var value: RDIValue
    public var isValid: Bool
    
    public init(
        value: RDIValue,
        isValid: Bool
    ) {
        self.value = value
        self.isValid = isValid
    }
}

public extension Array where Element == RDIValue {
    mutating func sanitize() {
        for (index, value) in enumerated() {
            /// Remove `biologicalSex` for any that have it set as `.notSet`
            if value.biologicalSex == .notSet {
                self[index].biologicalSex = nil
            }
        }
    }

    func sanitized() -> [RDIValue] {
        var array = self
        array.sanitize()
        return array
    }

    func isValidAfterAdding(_ value: RDIValue) -> Bool {
        
        switch value.biologicalSex {
        case .female:
            break
        case .male:
            break
        default:
            guard !self.containsBiologicalSex else {
                return false
            }
        }
        
        return true
    }
}

public extension Array where Element == RDIFormValue {
    
    var values: [RDIValue] {
        map { $0.value }
    }
    
    func isValidAfterAdding(_ value: RDIValue) -> Bool {
        values.isValidAfterAdding(value)
    }
    
    mutating func validate() {
        
        var checked: [RDIFormValue] = []
        
        for (index, formValue) in enumerated() {
            guard !checked.isEmpty else {
                /// First value is always valid
                self[index].isValid = true
                checked = [formValue]
                continue
            }
            
            let isValid = checked.isValidAfterAdding(formValue.value)
            self[index].isValid = isValid
        }
    }
    
    mutating func setValue(_ newValue: RDIFormValue, replacing existing: RDIValue?) {
        if let existing {
            guard let index = self.firstIndex(where: { $0.value == existing }) else {
                return
            }
            self[index] = newValue
        } else {
            self.append(newValue)
        }
    }
}

