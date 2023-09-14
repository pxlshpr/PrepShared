import XCTest
@testable import PrepShared
@testable import SwiftSugar

extension FoodQuantityConvertTests {
    
    //MARK: - Serving → Weight
    func test_Serving_Weight() throws {
        for testCase in TestCases.Serving_Weight {
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
    static let Serving_Weight = [
        FoodQuantityTestCase(
            quantity: FoodQuantity(
                0.5,
                Food(
                    serving: .init(100, .g)
                )
            ),
            equivalentWeights: [
                .g : 50,
            ]
        ),
        FoodQuantityTestCase(
            quantity: FoodQuantity(
                2.3,
                Food(
                    serving: .init(22, .tablespoonMetric), /// 15
                    density: .init(1.2, .oz, 0.8, .cupJapanTraditional) // 180.39
                )
            ),
            equivalentWeights: [
                .g : 178.92292135,
            ]
        ),
    ]
}
