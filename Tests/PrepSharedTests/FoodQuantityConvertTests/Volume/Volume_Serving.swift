import XCTest
@testable import PrepShared
@testable import SwiftSugar

extension FoodQuantityConvertTests {
    func testVolumeToServings() throws {
        for testCase in TestCases.Volume_Serving {
            
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
    static let Volume_Serving = [
        
        /// volume-based serving
        FoodQuantityTestCase(
            quantity: FoodQuantity(
                1.05, .tablespoonUS, /// 14.79
                Food(serving: .init(2, .cupImperial)) /// 284.13 mL
            ),
            equivalentServing: 0.02732816
        ),

        /// volume-based serving with non-default amount (shouldn't make a difference)
        FoodQuantityTestCase(
            quantity: FoodQuantity(
                1.05, .tablespoonUS, /// 14.79
                Food(
                    amount: .init(2.5), /// indicates 2.5 servings
                    serving: .init(2, .cupImperial) /// 284.13 mL
                )
            ),
            equivalentServing: 0.02732816
        ),

        /// weight-size-size-size based serving
        FoodQuantityTestCase(
            quantity: FoodQuantity(
                350, .mL,
                Food(
                serving: .init(0.2, "box"),
                density: .init(100, .g, 1, .cupJapanTraditional), /// 180.39 mL
                sizes: [
                    .init(2, "bottle", .init(4, .oz)),
                    .init(1.5, "pack", .init(3, "bottle")),
                    .init(0.5, "box", .init(2, "pack"))
                ]
            )),
            equivalentServing: 2.13874854
        ),

        //TODO: *** Convert these from Weight_Serving by swapping units ***
//        /// Volume-based serving (without density)
//        FoodQuantityTestCase(
//            quantity: FoodQuantity(100, .g, Food(serving: .init(25, .cupMetric))),
//            equivalentServing: nil
//        ),
//
//        /// Volume-based serving (with density)
//        FoodQuantityTestCase(
//            quantity: FoodQuantity(100, .g, Food(
//                serving: .init(25, .tablespoonUS),      /// 14.79 mL  x 25 = 369.75 mL
//                density: .init(100, .g, 2, .cupMetric)  /// 250 mL
//            )),
//            equivalentServing: 1.35226504
//        ),
//
//        /// weight-size based serving
//        FoodQuantityTestCase(
//            quantity: FoodQuantity(12, .g, Food(
//                serving: .init(3, "ball"),
//                sizes: [
//                    .init(name: "ball", quantity: 3, value: .init(12, .g))
//                ]
//            )),
//            equivalentServing: 1
//        ),
//
//        /// volume-size based serving
//        FoodQuantityTestCase(
//            quantity: FoodQuantity(120, .g, Food(
//                serving: .init(1, "bottle"),
//                density: .init(100, .g, 150, .ml),
//                sizes: [
//                    .init(name: "bottle", quantity: 2, value: .init(4, .cupMetric))
//                ]
//            )),
//            equivalentServing: 0.36
//        ),
//
//        /// weight-size-size based serving
//        FoodQuantityTestCase(
//            quantity: FoodQuantity(15, .g, Food(
//                serving: .init(0.5, "box"),
//                sizes: [
//                    .init(name: "ball", quantity: 3, value: .init(12, .g)),
//                    .init(name: "box", quantity: 1, value: .init(24, "ball")),
//                ]
//            )),
//            equivalentServing: 0.3125
//        ),
//
//        /// volume-size-size based serving
//        FoodQuantityTestCase(
//            quantity: FoodQuantity(120, .g, Food(
//                serving: .init(0.75, "pack"),
//                density: .init(100, .g, 1, .cupJapanTraditional), /// 180.39 mL
//                sizes: [
//                    .init(name: "bottle", quantity: 2, value: .init(4, .cupMetric)), /// 250 mL
//                    .init(name: "pack", quantity: 1.5, value: .init(3, "bottle"))
//                ]
//            )),
//            equivalentServing: 0.288624
//        ),
//
//
//        /// weight-size-size-size based serving
//        FoodQuantityTestCase(
//            quantity: FoodQuantity(150, .g, Food(
//                serving: .init(1.5, "carton"),
//                sizes: [
//                    .init(name: "ball", quantity: 3, value: .init(12, .g)),
//                    .init(name: "box", quantity: 1.5, value: .init(30, "ball")),
//                    .init(name: "carton", quantity: 5, value: .init(15, "box")),
//                ]
//            )),
//            equivalentServing: 0.41666667
//        ),
//
//        /// volumeprefixedsize-based serving
//        FoodQuantityTestCase(
//            quantity: FoodQuantity(1.7, .oz, Food(
//                serving: .init(0.5, "chopped4"),
//                sizes: [
//                    .init(name: "chopped", volumeUnit: .cupLatinAmerica,
//                          quantity: 1.5, value: .init(270, .g))
//                ]
//            )),
//            equivalentServing: 0.53549111
//        ),
//
//        /// volumeprefixedsize-size based serving
//        FoodQuantityTestCase(
//            quantity: FoodQuantity(14.3, .oz, Food(
//                serving: .init(0.8, "pack"),
//                sizes: [
//                    .init(name: "chopped", volumeUnit: .cupLatinAmerica,
//                          quantity: 1.5, value: .init(270, .g)),
//                    .init(name: "pack", quantity: 0.5, value: .init(2, "chopped4")),
//                ]
//            )),
//            equivalentServing: 0.70381632
//        ),
    ]
}
