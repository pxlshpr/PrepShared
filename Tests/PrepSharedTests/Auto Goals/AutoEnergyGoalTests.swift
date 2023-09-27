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
