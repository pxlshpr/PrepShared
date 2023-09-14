import XCTest
@testable import PrepShared
@testable import SwiftSugar

extension FoodQuantityConvertTests {
    
    //MARK: - Weight → Weight
    func testWeightToWeight() throws {
        for testCase in TestCases.Weight {
            for (weightUnit, expectation) in testCase.equivalentWeights {
                guard let result = testCase.quantity.convert(to: .weight(weightUnit)) else {
                    XCTFail()
                    return
                }
                assertEqual(result.value, expectation)
            }
        }
    }
}


extension TestCases {
    static let Weight = [
        FoodQuantityTestCase(
            quantity: FoodQuantity(1, .g, Food()),
            equivalentWeights: [
                .g : 1,
                .kg : 0.001,
                .mg : 1000,
                .oz : 0.03527396,
                .lb : 0.00220462
            ]
        ),
        FoodQuantityTestCase(
            quantity: FoodQuantity(30, .oz, Food()),
            equivalentWeights: [
                .g : 850.486,
                .kg : 0.850486,
                .mg : 850485.69,
                .oz : 30,
                .lb : 1.87
            ]
        )
    ]
}
