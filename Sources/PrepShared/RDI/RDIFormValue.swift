import Foundation

public struct RDIFormValue: Hashable, Equatable {
    public var value: RDIValue
    public var error: RDIValueError?
    
    public init(
        value: RDIValue,
        error: RDIValueError? = nil
    ) {
        self.value = value
        self.error = error
    }
    
    public var isValid: Bool {
        error == nil
    }
}

public extension Array where Element == RDIValue {

    var containsPositivePregnancyStatus: Bool {
        contains(where: { $0.pregnancyStatus == .lactating || $0.pregnancyStatus == .pregnant })
    }

    mutating func sanitize() {
        
        for (index, value) in enumerated() {
            /// Remove `biologicalSex` for any that have it set as `.notSet`
            if value.biologicalSex == .notSet {
                self[index].biologicalSex = nil
            }
            
            /// If any of the values contains a positive pregnancy status, then convert all `female` `.notSet` or `nil` statuses to `notPregnantOrLactating`
            if containsPositivePregnancyStatus {
                if value.biologicalSex == .female, (value.pregnancyStatus == nil || value.pregnancyStatus == .notSet) {
                    self[index].pregnancyStatus = .notPregnantOrLactating
                }
                if value.biologicalSex == .male {
                    self[index].pregnancyStatus = nil
                }
            }
            
            /// If we contain any smoking status, convert all the nil ones to be `false`
//            if containsSmokingStatus {
//                if value.isSmoker == nil {
//                    self[index].isSmoker = false
//                }
//            }
        }
    }

    func sanitized() -> [RDIValue] {
        var array = self
        array.sanitize()
        return array
    }

    func errorAfterAdding(_ newValue: RDIValue) -> RDIValueError? {
        for value in self {
            if let error = newValue.compatibilityError(with: value) {
                return error
            }
        }
        return nil
    }
}

extension RDIValue {
    func compatibilityError(with other: RDIValue) -> RDIValueError? {
        
        /// Now, if any of the params match, make sure they mistmatch via some other param as well (otherwise we have conflicting types)
        if (ageRange != nil ? ageRange == other.ageRange : true) {
            guard self.isDifferentExceptForAgeRange(from: other) else {
                return .duplicate
            }
        }
        
        if (biologicalSex != nil ? biologicalSex == other.biologicalSex : true) {
            guard self.isDifferentExceptForBiologicalSex(from: other) else {
                return .duplicate
            }
        }

        if (pregnancyStatus != nil ? pregnancyStatus == other.pregnancyStatus : true) {
            guard self.isDifferentExceptForPregnancyStatus(from: other) else {
                return .duplicate
            }
        }

        if (isSmoker != nil ? isSmoker == other.isSmoker : true) {
            guard self.isDifferentExceptForIsSmoker(from: other) else {
                return .duplicate
            }
        }

        return nil
    }
    
    func isDifferentExceptForBiologicalSex(from other: RDIValue) -> Bool {
        ageRange != other.ageRange
        || pregnancyStatus != other.pregnancyStatus
        || isSmoker != other.isSmoker
    }
    
    func isDifferentExceptForAgeRange(from other: RDIValue) -> Bool {
        biologicalSex != other.biologicalSex
        || pregnancyStatus != other.pregnancyStatus
        || isSmoker != other.isSmoker
    }

    func isDifferentExceptForPregnancyStatus(from other: RDIValue) -> Bool {
        biologicalSex != other.biologicalSex
        || ageRange != other.ageRange
        || isSmoker != other.isSmoker
    }

    func isDifferentExceptForIsSmoker(from other: RDIValue) -> Bool {
        biologicalSex != other.biologicalSex
        || ageRange != other.ageRange
        || pregnancyStatus != other.pregnancyStatus
    }
}

extension Array where Element == RDIValue {
    
    var containsAgeRange: Bool {
        contains { $0.ageRange != nil }
    }
    
    var containsBiologicalSex: Bool {
        contains {
            $0.biologicalSex != nil && $0.biologicalSex != .notSet
        }
    }
    
    var containsSmokingStatus: Bool {
        contains {
            $0.isSmoker == true
        }
    }
    
    var containsPregnancyStatus: Bool {
        contains {
            $0.pregnancyStatus != nil
            && $0.pregnancyStatus != .notSet
        }
    }
    
    var hasAllSmokingStatusCombos: Bool {
        count == 2
        && contains { $0.isSmoker == true }
        && contains { $0.isSmoker == false }
    }
    
    var groupedByAgeRange: [Bound: [RDIValue]] {
        var dict: [Bound: [RDIValue]] = [:]
        for value in self {
            guard let ageRange = value.ageRange else { return [:] }
            if let existing = dict[ageRange] {
                dict[ageRange] = existing + [value]
            } else {
                dict[ageRange] = [value]
            }
        }
        return dict
    }
    
    var hasAllParamCombosWithoutAgeRange: Bool {
        
        var withGender: Bool {
            let male = filter { $0.biologicalSex == .male }
            let female = filter { $0.biologicalSex == .female }
            
            /// Check that we have at least 1 value for both genders
            guard !male.isEmpty, !female.isEmpty else {
                return false
            }
            
            /// For male, check if we have all smoker combinations if we have the value
            if male.containsSmokingStatus {
                guard male.hasAllSmokingStatusCombos else { return false }
            }
            
            /// Then for female, check if any has pregnancyStatus
            if female.containsPregnancyStatus {
                
                /// If any has pregnancy status, check that we have both .lactating and .pregnant first
                guard female.contains(where: { $0.pregnancyStatus == .lactating }),
                      female.contains(where: { $0.pregnancyStatus == .pregnant }) else {
                    return false
                }
                
                /// Then check that we have notPregnantOrLactating, (filter them out) and do the smoking check on them like above
                let notPregnantOrLactating = female.filter { $0.pregnancyStatus == .notPregnantOrLactating }
                guard !notPregnantOrLactating.isEmpty else { return false }
                if notPregnantOrLactating.containsSmokingStatus {
                    guard notPregnantOrLactating.hasAllSmokingStatusCombos else { return false }
                }
                
            } else if female.containsSmokingStatus {
                /// If none has pregnancy status, simply check the smoking check like with male
                guard female.hasAllSmokingStatusCombos else { return false }
            }
            
            /// If we reach this point, then all available params have been provided
            return true
        }
        
        var withoutGender: Bool {
            if containsSmokingStatus {
                hasAllSmokingStatusCombos
            } else {
                /// No params, so only 1 value is allowed, returning true if not empty
                !isEmpty
            }
        }
        
        return if !containsBiologicalSex {
            withoutGender
        } else {
            withGender
        }
    }
}

public enum RDIError: Error, Equatable {
    case missingAgeRange
    case value(RDIValueError)
    case incompleteValues
}

public enum RDIValueError: Error, Equatable {
    case ageRangeMismatch
    case biologicalSexMismatch
    case pregnancyStatusMismatch
    case isSmokerMismatch
    case duplicate
}

public extension Array where Element == RDIValue {
    func validate() -> RDIError? {
        
        let result = allParamCombos()
        switch result {
        case .success(let combos):
            for params in combos {
                guard compatibleValue(for: params) != nil else {
                    return .incompleteValues
                }
            }
            return nil
        case .failure(let error):
            return error
        }
    }
    
    func compatibleValue(for params: RDIParams) -> RDIValue? {
        
        /// Go through the goals and find a compatible one matching the provided params and energyInKcal
        for rdiValue in self {

            /// If goal has params set (like age range etc), and we don't have them available, disqualify the goal and continue
            if let ageRange = rdiValue.ageRange {
                guard let age = params.age, ageRange.contains(age) else { continue }
            }
            if let sex = rdiValue.biologicalSex {
                guard params.sex == sex else { continue }
            }
            if let pregnancyStatus = rdiValue.pregnancyStatus {
                guard params.pregnancyStatus == pregnancyStatus else { continue }
            }
            if let isSmoker = rdiValue.isSmoker {
                guard params.isSmoker == isSmoker else { continue }
            }

            return rdiValue
        }
        
        /// No compatible value found
        return nil
    }
}

public extension Array where Element == RDIFormValue {
    
    var values: [RDIValue] {
        map { $0.value }
    }

    mutating func validateAndSetErrors() -> RDIError? {
        
        var values = values
        values.sanitize()
        for (index, value) in values.enumerated() {
            self[index].value = value
        }
        
        var checked: [RDIFormValue] = []
        
        var firstValueError: RDIValueError? = nil
        for (index, formValue) in enumerated() {
            guard !checked.isEmpty else {
                /// First value is always valid
                self[index].error = nil
                checked = [formValue]
                continue
            }
            
            let error = checked.values.errorAfterAdding(formValue.value)
            if firstValueError == nil, let error {
                firstValueError = error
            }
            self[index].error = error
            
            checked.append(self[index])
        }
        
        if let firstValueError {
            return .value(firstValueError)
        }
        
        return values.validate()
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

