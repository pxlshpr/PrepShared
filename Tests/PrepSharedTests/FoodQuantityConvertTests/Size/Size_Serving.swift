import XCTest
@testable import PrepShared
@testable import SwiftSugar

extension FoodQuantityConvertTests {
    func test_Size_Serving() throws {
        for testCase in TestCases.Size_Serving {

            let result = testCase.quantity.convert(to: .serving)

            if let expectedServing = testCase.equivalentServing {
                guard let result else {
                    XCTFail()
                    return
                }
                assertEqual(result.value, expectedServing)
            } else {
                XCTAssertNil(result)
            }
        }
    }
}

extension TestCases {
    static let Size_Serving = [

        FoodQuantityTestCase(
            quantity: FoodQuantity(
                1, "container",
                Food(
                    serving: .init(0.33, "bar"),
                    sizes: [
                        .init(1, "bar", .init(99, .g)),
                        .init(1, "container", .init(18)),
                    ]
                )
            )!,
            equivalentServing: 18
        ),
        
        FoodQuantityTestCase(
            quantity: FoodQuantity(
                2.3, "carton",  /// 102.051 mL
                Food(
                    serving: .init(1, .cupJapanTraditional, "chopped5"), /// 180.39 mL
                    sizes: [
                        .init(2, .fluidOunceUSNutritionLabeling, "chopped", .init(370, .g)), /// 30 mL
                        .init(1.5, "packet", .init(3, .tablespoonUS, "chopped5")), /// 2 tbsp chopped = 14.79 mL
                        .init(5, "carton", .init(15, "packet")) /// 3 packet = 44.37 mL
                    ]
                ))!,
            equivalentServing: 1.13144853
        ),
        /// volume-based serving
        FoodQuantityTestCase(
            quantity: FoodQuantity(
                1, "bottle",
                Food(
                    serving: .init(100, .mL),
                    sizes: [
                        .init(1.5, "bottle", .init(335, .mL)),
                    ]
                )
            )!,
            equivalentServing: 2.23333333
        ),

        FoodQuantityTestCase(
            quantity: FoodQuantity(
                1, "leaf",
                Food(
                    mockName: "Spinach",
                    serving: .init(1, .cupMetric),
                    density: .init(30, .g, 1, .cupMetric),
                    sizes: [
                        .init(1, "leaf", .init(10, .g)),
                    ]
                )
            )!,
            equivalentServing: 0.3333
        ),

        /// weight-size-size-size based serving
        FoodQuantityTestCase(
            quantity: FoodQuantity(
                15, "bottle",
                Food(
                    serving: .init(0.2, "box"), /// 0.8 pack =  1.6 bottle
                    density: .init(100, .g, 1, .cupJapanTraditional),
                    sizes: [
                        .init(2, "bottle", .init(4, .oz)),
                        .init(1.5, "pack", .init(3, "bottle")), ///  2 bottle
                        .init(0.5, "box", .init(2, "pack")) /// 4 pack
                    ]
                ))!,
            equivalentServing: 9.375
        ),

        FoodQuantityTestCase(
            quantity: FoodQuantity(
                0.75, .cupMetric, "chopped5",  /// 250 mL
                Food(
                    serving: .init(1, .cupJapanTraditional, "chopped5"), /// 180.39 mL
                    sizes: [
                        .init(2, .fluidOunceUSNutritionLabeling, "chopped", .init(370, .g)), /// 30 mL
                        .init(1.5, "packet", .init(3, "chopped5")), /// 2 chopped
                        .init(5, "carton", .init(15, "packet")) /// 3 packet
                    ]
                ))!,
            equivalentServing: 1.0394146
        ),

        FoodQuantityTestCase(
            quantity: FoodQuantity(
                2.3, "carton",  /// 250 mL
                Food(
                    serving: .init(1, .cupJapanTraditional, "chopped5"), /// 180.39 mL
                    sizes: [
                        .init(2, .fluidOunceUSNutritionLabeling, "chopped", .init(370, .g)), /// 30 mL
                        .init(1.5, "packet", .init(3, "chopped5")), /// 2 floz chopped = 60 mL
                        .init(5, "carton", .init(15, "packet")) /// 3 packet =  180 mL
                    ]
                ))!,
            equivalentServing: 2.29502744
        ),
    ]
}
