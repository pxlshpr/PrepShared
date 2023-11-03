import Foundation

public extension Array where Element == RDIValue {
    
    var hasAllParamCombos: Bool {
        
        guard isValid else { return false }
        
        var withAgeRange: Bool {
            let grouped = groupedByAgeRange

            for (_, values) in grouped {
                /// For each group, if have gender (and optionally pregnancyStatus) or isSmoker, check that we have all combinations, otherwise fail early
                guard values.hasAllParamCombosWithoutAgeRange else { return false }
            }

            let ageRanges = grouped.map { $0.key }
            return ageRanges.spansZeroToInfinity
        }
        
        return if !containsAgeRange {
            hasAllParamCombosWithoutAgeRange
        } else {
            withAgeRange
        }
        
        //TODO: Change how we do this:
        /// -[ ] Write a function that adds a value to the array of values, doing the following checks
        /// -[ ] If there is an age range—make sure the range does not overlap with one that we already have, unless its providing a param that does not exist (ie different gender, smoking or pregnancy status)
        /// -[ ] ?
        /// -[ ] If any of these checks fail, don’t add the value and return an error that we present to the user, as a validation check for ourselves when entering these
        /// -[ ] RDIForm.ValueForm should allow turning off gender and smoker (when specifying infants, for example)
        
    }
    
    var isValid: Bool {
        /// Ensure age range is in all if specified
        if containsAgeRange {
            guard allSatisfy({ $0.ageRange != nil  }) else { return false }
        }
        return true
    }
}

extension Array where Element == RDIValue {
    
    var containsAgeRange: Bool {
        contains { $0.ageRange != nil }
    }
    
    var containsGender: Bool {
        contains { $0.gender != nil }
    }
    
    var containsSmokingStatus: Bool {
        contains { $0.isSmoker != nil }
    }
    
    var containsPregnancyStatus: Bool {
        contains { $0.pregnancyStatus != nil }
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
            let male = filter { $0.gender == .male }
            let female = filter { $0.gender == .female }
            
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
        
        return if !containsGender {
            withoutGender
        } else {
            withGender
        }
    }
}
