import XCTest
@testable import PrepShared

let energyUnit = EnergyUnit.kcal

final class AutoEnergyGoalTests: XCTestCase {
    
    func testAutoEnergyGoal() throws {
        for testCase in AutoEnergyTestCases {
            let planFields = PlanFields(testCase.plan)
            let energyGoal = planFields.generatedAutoEnergyGoal(using: energyUnit)
            assertEqual(energyGoal, testCase.expectedGoal)
        }
    }
}

//let AutoEnergyTestCases = [CurrentAutoEnergyTestCase]
let AutoEnergyTestCases = [CurrentAutoEnergyTestCase] + PassingAutoEnergyTestCases

let CurrentAutoEnergyTestCase: AutoGoalTestCase = 
AutoGoalTestCase.expectedEnergy(
    (nil, 2433.14),
    carb: (20, 100),
    fat: (nil, 150),
    protein: (130, 180)
)

let PassingAutoEnergyTestCases: [AutoGoalTestCase] = [
    AutoGoalTestCase.expectedEnergy(
        (1125.26, 2433.14),
        carb: (20, 100),
        fat: (60, 150),
        protein: (130, 180)
    ),
    AutoGoalTestCase.expectedEnergy(
        nil,
        carb: (20, nil),
        fat: (nil, 150),
        protein: (130, 180)
    )
]


//MARK: - AutoGoalTestCase

struct AutoGoalTestCase {
    let plan: Plan
    let expectedGoal: Goal?
    
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

//MARK: - Convenience Helpers

extension Plan {
    static func plan(_ goals: [Goal]) -> Plan {
        .init(
            name: "",
            emoji: "",
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

//MARK: - Assertions

func assertEqual(_ goal: Goal?, _ other: Goal?) {
    switch (goal, other) {
    case (.some(let goal), .some(let other)):   assertEqual(goal, other)
    case (.none, .some), (.some, .none):        XCTFail()
    case (.none, .none):                        break
    }
}

func assertEqual(_ goal: Goal, _ other: Goal) {
    XCTAssertEqual(goal.type, other.type)
    assertEqual(goal.bound, other.bound)
    assertEqual(goal.calculatedBound, other.calculatedBound)
}

func assertEqual(_ bound: GoalBound, _ other: GoalBound) {
    assertEqual(bound.lower, other.lower)
    assertEqual(bound.upper, other.upper)
}

func assertEqual(_ double: Double?, _ other: Double?) {
    switch (double, other) {
    case (.some(let double), .some(let other)): assertEqual(toPlaces: 0, double, other)
    case (.none, .some), (.some, .none):        XCTFail()
    case (.none, .none):                        break
    }
}
