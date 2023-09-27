import Foundation
@testable import PrepShared

struct AutoGoalTestCase {
    let plan: Plan
    let expectedGoal: Goal?
}

extension AutoGoalTestCase {
    static func expectedEnergy(
        _ energy: (Double?, Double?)?,
        carb: (Double?, Double?),
        fat: (Double?, Double?),
        protein: (Double?, Double?)
    ) -> AutoGoalTestCase {
        .init(
            plan: Plan.plan([
                Goal.fixedMacro(.carb, carb),
                Goal.fixedMacro(.fat, fat),
                Goal.fixedMacro(.protein, protein)
            ]),
            expectedGoal: energy != nil ? Goal.fixedEnergy(energy!) : nil
        )
    }
}

extension AutoGoalTestCase {
    static func expectedFat(
        _ fat: (Double?, Double?)?,
        energy: (Double?, Double?),
        carb: (Double?, Double?),
        protein: (Double?, Double?)
    ) -> AutoGoalTestCase {
        .init(
            plan: Plan.plan([
                Goal.fixedEnergy(energy),
                Goal.fixedMacro(.carb, carb),
                Goal.fixedMacro(.protein, protein)
            ]),
            expectedGoal: fat != nil ? Goal.fixedMacro(.fat, fat!) : nil
        )
    }
    
    static func expectedCarb(
        _ carb: (Double?, Double?)?,
        energy: (Double?, Double?),
        fat: (Double?, Double?),
        protein: (Double?, Double?)
    ) -> AutoGoalTestCase {
        .init(
            plan: Plan.plan([
                Goal.fixedEnergy(energy),
                Goal.fixedMacro(.fat, fat),
                Goal.fixedMacro(.protein, protein)
            ]),
            expectedGoal: carb != nil ? Goal.fixedMacro(.carb, carb!) : nil
        )
    }
    
    static func expectedProtein(
        _ protein: (Double?, Double?)?,
        energy: (Double?, Double?),
        carb: (Double?, Double?),
        fat: (Double?, Double?)
    ) -> AutoGoalTestCase {
        .init(
            plan: Plan.plan([
                Goal.fixedEnergy(energy),
                Goal.fixedMacro(.fat, fat),
                Goal.fixedMacro(.carb, carb)
            ]),
            expectedGoal: protein != nil ? Goal.fixedMacro(.protein, protein!) : nil
        )
    }
}
