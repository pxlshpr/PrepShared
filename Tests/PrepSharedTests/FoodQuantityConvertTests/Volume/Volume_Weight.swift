import XCTest
@testable import PrepShared
@testable import SwiftSugar

extension FoodQuantityConvertTests {
    func testVolumeToWeight() throws {
        for testCase in TestCases.VolumeWithDensity {
            for (weightUnit, expectedWeight) in testCase.equivalentWeights {
                guard let weight = testCase.quantity.convert(to: .weight(weightUnit)) else {
                    XCTFail()
                    return
                }
                assertEqual(weight.value, expectedWeight)
            }
        }
    }
}

extension TestCases {
    static let VolumeWithDensity = [
        FoodQuantityTestCase(
            quantity: FoodQuantity(
                100, .mL, Food(
                    density: FoodDensity(100, .g, 100, .mL)
                )
            ),
            equivalentWeights: [
                .g : 100,
            ]
        ),
    ]
}

