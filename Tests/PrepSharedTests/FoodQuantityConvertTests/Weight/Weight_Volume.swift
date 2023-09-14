import XCTest
@testable import PrepShared
@testable import SwiftSugar

extension FoodQuantityConvertTests {
    //MARK: - Weight → Volume
    func testWeightToVolume() throws {
        for testCase in TestCases.WeightWithDensity {
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
    static let WeightWithDensity = [
        FoodQuantityTestCase(
            quantity: FoodQuantity(
                value: 100,
                unit: .weight(.g),
                food: Food(density: FoodDensity(100, .g, 1, .cupMetric))
            ),
            equivalentVolumes: [
                .cupMetric : 1,
            ]
        ),
        FoodQuantityTestCase(
            quantity: FoodQuantity(
                value: 100,
                unit: .weight(.g),
                food: Food(density: FoodDensity(100, .g, 1, .cupMetric)) /// 250 ml
            ),
            equivalentVolumes: [
                .cupJapanTraditional : 1.38588614,
                .tablespoonUS: 16.90331305
            ]
        ),
        FoodQuantityTestCase(
            quantity: FoodQuantity(
                value: 50,
                unit: .weight(.g),
                food: Food(density: FoodDensity(100, .g, 1, .cupMetric)) /// 250 ml
            ),
            equivalentVolumes: [
                .cupJapanTraditional : 0.69294307,
                .tablespoonUS: 8.45165652
            ]
        )
    ]
}

