import Foundation

extension PregnancyStatus {
    static var femaleOptions: [PregnancyStatus] {
        [.pregnant, .lactating, .notPregnantOrLactating]
    }
    
    static func options(for biologicalSex: BiologicalSex) -> [PregnancyStatus] {
        switch biologicalSex {
        case .female:   femaleOptions
        default:        [.notSet]
        }
    }
}

extension BiologicalSex {
    static var options: [BiologicalSex] {
        [.male, .female]
    }
}

extension Bool {
    static func isSmokerOptions(_ biologicalSex: BiologicalSex = .male, _ pregnancyStatus: PregnancyStatus = .notSet) -> [Bool] {
        switch biologicalSex {
        case .female:
            switch pregnancyStatus {
            case .pregnant, .lactating: [false]
            default:                    [true, false]
            }
        default:
            [true, false]
        }
    }

}

extension RDIParams {
    static func allCombos(
        withAgeRanges ageRanges: [Bound],
        withIsSmoker: Bool = true,
        withPregnancyStatus: Bool = true,
        withBiologicalSex: Bool = true
    ) -> [RDIParams] {
        var params: [RDIParams] = []
        for ageRange in ageRanges {
    
            if withBiologicalSex {
                
                for biologicalSex in BiologicalSex.options {
                    if withPregnancyStatus {
                        for pregnancyStatus in PregnancyStatus.options(for: biologicalSex) {
                            if withIsSmoker {
                                for isSmoker in Bool.isSmokerOptions(biologicalSex, pregnancyStatus) {
                                    params.append(.init(
                                        age: ageRange.lower,
                                        sex: biologicalSex,
                                        pregnancyStatus: pregnancyStatus,
                                        isSmoker: isSmoker
                                    ))
                                }
                            } else {
                                params.append(.init(
                                    age: ageRange.lower,
                                    sex: biologicalSex,
                                    pregnancyStatus: pregnancyStatus
                                ))
                            }
                        }
                    } else {
                        if withIsSmoker {
                            for isSmoker in Bool.isSmokerOptions(biologicalSex) {
                                params.append(.init(
                                    age: ageRange.lower,
                                    sex: biologicalSex,
                                    isSmoker: isSmoker
                                ))
                            }
                        } else {
                            params.append(.init(
                                age: ageRange.lower,
                                sex: biologicalSex
                            ))
                        }
                    }
                }
                
            } else {
                
                if withIsSmoker {
                    for isSmoker in Bool.isSmokerOptions() {
                        params.append(.init(
                            age: ageRange.lower,
                            isSmoker: isSmoker
                        ))
                    }
                } else {
                    params.append(.init(
                        age: ageRange.lower
                    ))
                }
                
            }
        }
        return params
    }
    
    static func allCombosWithoutAgeRanges(
        withIsSmoker: Bool = true,
        withPregnancyStatus: Bool = true,
        withBiologicalSex: Bool = true
    ) -> [RDIParams] {
        var params: [RDIParams] = []
        if withBiologicalSex {
            
            for biologicalSex in BiologicalSex.options {
                if withPregnancyStatus {
                    for pregnancyStatus in PregnancyStatus.options(for: biologicalSex) {
                        if withIsSmoker {
                            for isSmoker in Bool.isSmokerOptions(biologicalSex, pregnancyStatus) {
                                params.append(.init(
                                    sex: biologicalSex,
                                    pregnancyStatus: pregnancyStatus,
                                    isSmoker: isSmoker
                                ))
                            }
                        } else {
                            params.append(.init(
                                sex: biologicalSex,
                                pregnancyStatus: pregnancyStatus
                            ))
                        }
                    }
                } else {
                    if withIsSmoker {
                        for isSmoker in Bool.isSmokerOptions(biologicalSex) {
                            params.append(.init(
                                sex: biologicalSex,
                                isSmoker: isSmoker
                            ))
                        }
                    } else {
                        params.append(.init(
                            sex: biologicalSex
                        ))
                    }
                }
            }
            
        } else {
            
            if withIsSmoker {
                for isSmoker in Bool.isSmokerOptions() {
                    params.append(.init(
                        isSmoker: isSmoker
                    ))
                }
            } else {
                /// No params to test
            }
            
        }
        return params
    }
}

public extension Array where Element == RDIValue {

    var allAgeRanges: [Bound] {
        groupedByAgeRange.map { $0.key }
    }
    
    func allParamCombos() -> Result<[RDIParams], RDIError> {
        let ageRanges: [Bound]? = containsAgeRange ? allAgeRanges : nil
        if let ageRanges {
            guard ageRanges.spansZeroToInfinity else {
                //TODO: Return an error saying age ranges don't span
                return .failure(.missingAgeRange)
            }
        }
        
        let params = if let ageRanges {
            RDIParams.allCombos(
                withAgeRanges: ageRanges,
                withIsSmoker: containsSmokingStatus,
                withPregnancyStatus: containsPregnancyStatus,
                withBiologicalSex: containsBiologicalSex
            )
        } else {
            RDIParams.allCombosWithoutAgeRanges(
                withIsSmoker: containsSmokingStatus,
                withPregnancyStatus: containsPregnancyStatus,
                withBiologicalSex: containsBiologicalSex
            )
        }
        return .success(params)
    }
    
//    var hasAllParamCombos_: Bool {
//        guard isValid else { return false }
//        
//        var withAgeRange: Bool {
//            let grouped = groupedByAgeRange
//
//            for (_, values) in grouped {
//                /// For each group, if have sex (and optionally pregnancyStatus) or isSmoker, check that we have all combinations, otherwise fail early
//                guard values.hasAllParamCombosWithoutAgeRange else { return false }
//            }
//
//            let ageRanges = grouped.map { $0.key }
//            return ageRanges.spansZeroToInfinity
//        }
//        
//        return if !containsAgeRange {
//            hasAllParamCombosWithoutAgeRange
//        } else {
//            withAgeRange
//        }
//        
//        //TODO: Change how we do this:
//        /// -[ ] Write a function that adds a value to the array of values, doing the following checks
//        /// -[ ] If there is an age range—make sure the range does not overlap with one that we already have, unless its providing a param that does not exist (ie different sex, smoking or pregnancy status)
//        /// -[ ] ?
//        /// -[ ] If any of these checks fail, don’t add the value and return an error that we present to the user, as a validation check for ourselves when entering these
//        /// -[ ] RDIForm.ValueForm should allow turning off sex and smoker (when specifying infants, for example)
//    }
    
//    var isValid: Bool {
//        /// Ensure age range is in all if specified
//        if containsAgeRange {
//            guard allSatisfy({ $0.ageRange != nil  }) else { return false }
//        }
//        return true
//    }
}
