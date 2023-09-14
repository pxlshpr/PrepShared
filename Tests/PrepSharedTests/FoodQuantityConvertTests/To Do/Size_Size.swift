import XCTest
@testable import PrepShared
@testable import SwiftSugar

extension FoodQuantityConvertTests {

    func test_Size_Size() throws {
        for testCase in TestCases.Size_Size {
            for sizeTest in testCase.equivalentSizes {
                let volumePrefixUnit = sizeTest.0
                let sizeId = sizeTest.1
                let expectedValue = sizeTest.2

                guard let foodSize = testCase.quantity.food.size(for: sizeId),
                      let size = FoodQuantity.Size(foodSize: foodSize, in: testCase.quantity.food),
                      let result = testCase.quantity.convert(to: .size(size, volumePrefixUnit))
                else {
                    XCTFail()
                    return
                }
                assertEqual(result.value, expectedValue)
            }
        }
    }
}

extension TestCases {

    static let Size_Size = [
        /// serving-based size
        FoodQuantityTestCase(
            quantity: FoodQuantity(
                0.33, "bar",
                Food(
                    serving: .init(0.33, "bar"),
                    sizes: [
                        .init(1, "bar", .init(99, .g)),
                        .init(1, "container", .init(18)),
                    ]
                )
            )!,
            equivalentSizes: [
                (nil, "container", 0.05555556),
            ]
        ),
        
        /// serving-based size
//        FoodQuantityTestCase(
//            quantity: FoodQuantity(
//                1, "container",
//                Food(
//                    serving: .init(0.33, "bar"),
//                    sizes: [
//                        .init(1, "bar", .init(99, .g)),
//                        .init(1, "container", .init(18)),
//                    ]
//                )
//            )!,
//            equivalentSizes: [
//                (nil, "bar", 5.94),
//            ]
//        ),
//
//        /// serving-based size
//        FoodQuantityTestCase(
//            quantity: FoodQuantity(
//                2, "container",
//                Food(
//                    serving: .init(30, .g),
//                    sizes: [
//                        .init(1, "scoop", .init(1)),
//                        .init(1, "container", .init(74, "scoop")),
//                    ]
//                )
//            )!,
//            equivalentSizes: [
//                (nil, "scoop", 148),
//            ]
//        ),
//
//        /// serving-based size
//        FoodQuantityTestCase(
//            quantity: FoodQuantity(
//                1.5, "scoop",
//                Food(
//                    serving: .init(30, .g),
//                    sizes: [
//                        .init(1, "scoop", .init(1)),
//                        .init(1, "container", .init(74, "scoop")),
//                    ]
//                )
//            )!,
//            equivalentSizes: [
//                (nil, "container", 0.02027027027027),
//            ]
//        ),
//
//        /// weight-based size
//        FoodQuantityTestCase(
//            quantity: FoodQuantity(
//                1.5, "scoop",
//                Food(
//                    sizes: [
//                        .init(1, "scoop", .init(30.4, .g)),
//                        .init(1, "container", .init(74, "scoop")),
//                    ]
//                )
//            )!,
//            equivalentSizes: [
//                (nil, "container", 0.02027027027027),
//            ]
//        ),
//
//        /// volumeprefixedsize (weight-based)
//        FoodQuantityTestCase(
//            quantity: FoodQuantity(
//                1.5, .cupJapanTraditional, "chopped4", /// 180.39 mL
//                Food(
//                    density: .init(100, .g, 90, .ml),
//                    sizes: [
//                        .init(0.5, .cupUSCustomary, "chopped", .init(135, .g)), /// 236.59 mL
//                        .init(2, .cupUSCustomary, "pureed", .init(600, .g)),    /// 236.59 mL
//                        .init(1, .cupUSCustomary, "sliced", .init(200, .g)),    /// 236.59 mL
//                        .init(2, "medium", .init(100, .g)),
//                        .init(2, "small", .init(75, .g)),
//                        .init(3, "bottle", .init(200, .ml)),
//                    ]
//                )
//            )!,
//            equivalentSizes: [
//                (nil, "medium", 6.17591192),
//                (.cupUSCustomary, "pureed4", 1.02931865),
//                (.tablespoonUS, "pureed4", 16.46561866),
//                (nil, "bottle", 4.16874054),
//            ]
//        ),
//
//        /// volume-based size
//        FoodQuantityTestCase(
//            quantity: FoodQuantity(
//                1, "bottle",
//                Food(
//                    sizes: [
//                        .init(1, "bottle", .init(200, .ml)),
//                        .init(2, "container", .init(5, "bottle")),
//                        .init(1, "box", .init(3, "container")),
//                    ]
//                )
//            )!,
//            equivalentSizes: [
//                (nil, "container", 0.4),
//                (nil, "box", 0.13333333),
//            ]
//        ),

    ]
}

