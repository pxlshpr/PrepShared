import Foundation
@testable import PrepShared

extension Plan {
    static func plan(_ goals: [Goal]) -> Plan {
        .init(
            name: "",
            goals: goals
        )
    }
}

extension Goal {
    static func fixedEnergy(_ values: (Double?, Double?)) -> Goal {
        let bound = GoalBound(lower: values.0, upper: values.1)
        return self.init(
            type: .energy(.fixed(energyUnit)),
            bound: bound,
            calculatedBound: bound
        )
    }

    static func fixedMacro(_ macro: Macro, _ values: (Double?, Double?)) -> Goal {
        let bound = GoalBound(lower: values.0, upper: values.1)
        return self.init(
            type: .macro(.fixed, macro),
            bound: bound,
            calculatedBound: bound
        )
    }
}
