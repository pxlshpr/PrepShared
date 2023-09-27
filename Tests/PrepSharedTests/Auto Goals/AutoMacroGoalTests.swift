import XCTest
@testable import PrepShared

final class AutoEnergyMacroTests: XCTestCase {
    func testAutoMacroGoal() throws {
        for testCase in AutoMacroTestCases {
            let planFields = PlanFields(testCase.plan)
            let macroGoal = planFields.generatedAutoMacroGoal()
            assertEqual(macroGoal, testCase.expectedGoal)
        }
    }
}

//let AutoMacroTestCases = [CurrentAutoMacroTestCase]
//let AutoMacroTestCases = [CurrentAutoMacroTestCase] + PassingAutoMacroTestCases
let AutoMacroTestCases = PassingAutoMacroTestCases

//let CurrentAutoMacroTestCase: AutoGoalTestCase =
//AutoGoalTestCase.expectedFat(
//    (130.22, 226.17),
//    energy: (1500, 1800),
//    carb: (nil, 40),
//    protein: (130, 180)
//)

let PassingAutoMacroTestCases = PassingAutoFatTestCases + PassingAutoCarbTestCases + PassingAutoProteinTestCases

let PassingAutoFatTestCases: [AutoGoalTestCase] = [
    AutoGoalTestCase.expectedFat(
        (130.22, 226.17),
        energy: (2000, 2500),
        carb: (nil, 35),
        protein: (130, 180)
    ),
    AutoGoalTestCase.expectedFat(
        (130.22, nil),
        energy: (2000, nil),
        carb: (nil, 35),
        protein: (130, 180)
    ),
    AutoGoalTestCase.expectedFat(
        (nil, 226.17),
        energy: (nil, 2500),
        carb: (nil, 35),
        protein: (130, 180)
    ),
    AutoGoalTestCase.expectedFat(
        (nil, 210.18),
        energy: (nil, 2500),
        carb: (35, nil),
        protein: (130, 180)
    ),
    AutoGoalTestCase.expectedFat(
        nil,
        energy: (2000, nil),
        carb: (35, nil),
        protein: (130, 180)
    )
]

let PassingAutoProteinTestCases: [AutoGoalTestCase] = [
    AutoGoalTestCase.expectedProtein(
        (0, 340),
        energy: (2000, 2500),
        carb: (nil, 35),
        fat: (130.22, 226.17)
    ),
    AutoGoalTestCase.expectedProtein(
        (136.71, nil),
        energy: (2000, nil),
        carb: (nil, 35),
        fat: (60, 150)
    ),
//    AutoGoalTestCase.expectedFat(
//        (nil, 226.17),
//        energy: (nil, 2500),
//        carb: (nil, 35),
//        protein: (130, 180)
//    ),
//    AutoGoalTestCase.expectedFat(
//        (nil, 210.18),
//        energy: (nil, 2500),
//        carb: (35, nil),
//        protein: (130, 180)
//    ),
//    AutoGoalTestCase.expectedFat(
//        nil,
//        energy: (2000, nil),
//        carb: (35, nil),
//        protein: (130, 180)
//    )
]

let PassingAutoCarbTestCases: [AutoGoalTestCase] = [
//    AutoGoalTestCase.expectedFat(
//        (130.22, 226.17),
//        energy: (2000, 2500),
//        carb: (nil, 35),
//        protein: (130, 180)
//    ),
//    AutoGoalTestCase.expectedFat(
//        (130.22, nil),
//        energy: (2000, nil),
//        carb: (nil, 35),
//        protein: (130, 180)
//    ),
//    AutoGoalTestCase.expectedFat(
//        (nil, 226.17),
//        energy: (nil, 2500),
//        carb: (nil, 35),
//        protein: (130, 180)
//    ),
    AutoGoalTestCase.expectedCarb(
        (nil, 363.69),
        energy: (nil, 2500),
        fat: (60, nil),
        protein: (130, 180)
    ),
//    AutoGoalTestCase.expectedFat(
//        nil,
//        energy: (2000, nil),
//        carb: (35, nil),
//        protein: (130, 180)
//    )
]
