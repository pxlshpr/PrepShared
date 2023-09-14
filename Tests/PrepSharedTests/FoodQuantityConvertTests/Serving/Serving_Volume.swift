import XCTest
@testable import PrepShared
@testable import SwiftSugar

extension FoodQuantityConvertTests {
    func test_Serving_Volume() throws {
        for testCase in TestCases.Serving_Volume {
            for (volumeUnit, expectation) in testCase.equivalentVolumes {
                guard let result = testCase.quantity.convert(to: .volume(volumeUnit))
                else {
                    XCTFail()
                    return
                }
                XCTAssertEqual(
                    result.value.rounded(toPlaces: 2),
                    expectation.rounded(toPlaces: 2)
                )
            }
        }
    }
}

extension TestCases {
    static let Serving_Volume = [
        FoodQuantityTestCase(
            quantity: FoodQuantity(
                1,
                Food(
                    serving: .init(100, .mL)
                )
            ),
            equivalentVolumes: [
                .mL : 100,
            ]
        ),
        FoodQuantityTestCase(
            quantity: FoodQuantity(
                0.3,
                Food(
                    serving: .init(100, .g),
                    density: .init(200, .g, 150, .mL)
                )
            ),
            equivalentVolumes: [
                .mL : 22.5,
            ]
        ),
    ]
}

