import XCTest
@testable import PrepShared
@testable import SwiftSugar

extension FoodQuantityConvertTests {
    func testWeightToSize() throws {
        for testCase in TestCases.Weight_Size {
            
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
    static let Weight_Size = [

        /// weight based sizes
        FoodQuantityTestCase(
            quantity: FoodQuantity(
                150, .g,
                Food(
                    sizes: [
                        .init(name: "ball", quantity: 3, value: .init(12, .g)),
                        .init(name: "box", quantity: 1.5, value: .init(30, "ball")),
                        .init(name: "carton", quantity: 5, value: .init(15, "box")),
                    ]
                )
            ),
            equivalentSizes: [
                (nil, "ball", 37.5),
                (nil, "box", 1.875),
                (nil, "carton", 0.625)
            ]
        ),

        /// volume-prefixed size based sizes
        FoodQuantityTestCase(
            quantity: FoodQuantity(
                5.29109, .oz,
                Food(
                    sizes: [
                        .init(2, .cupJapanTraditional, "chopped", .init(370, .g)), /// 180.39 mL
                        .init(1.5, "packet", .init(3, "chopped4")),
                        .init(5, "carton", .init(15, "packet"))
                    ]
                )
            ),
            equivalentSizes: [
                (nil, "chopped4", 0.81081081), /// cups
                (nil, "packet", 0.40540541),
                (nil, "carton", 0.13513514),
                (.tablespoonUS, "chopped4", 9.88926046), /// tablespoons (assuming tablespoon US = 14.79 mL)
            ]
        ),

        /// volume based sizes
        FoodQuantityTestCase(
            quantity: FoodQuantity(
                1250, .g,
                Food(
                    density: .init(100, .g, 1, .cupJapanTraditional), /// 180.39 mL
                    sizes: [
                        .init(2, "bottle", .init(4, .cupMetric)), /// 250 mL
                        .init(1.5, "pack", .init(3, "bottle")),
                        .init(0.5, "box", .init(2, "pack"))
                    ]
                )
            ),
            equivalentSizes: [
                (nil, "bottle", 4.50975),
                (nil, "pack", 2.254875),
                (nil, "box", 0.56371875)
            ]
        ),
        
        /// serving-based sizes with a weight-based serving
        FoodQuantityTestCase(
            quantity: FoodQuantity(
                100, .g,
                Food(
                    serving: .init(50, .g),
                    sizes: [
                        .init(0.75, "bottle", .init(1)),
                        .init(1.5, "pack", .init(3, "bottle")),
                        .init(0.5, "box", .init(2, "pack"))
                    ]
                )
            ),
            equivalentSizes: [
                (nil, "bottle", 1.5),
                (nil, "pack", 0.75),
                (nil, "box", 0.1875)
            ]
        ),
        
        /// serving-based sizes with a volume-based serving
        FoodQuantityTestCase(
            quantity: FoodQuantity(
                5.05, .kg,
                Food(
                    serving: .init(2, .cupImperial), /// 284.13 mL
                    density: .init(100, .g, 0.5, .cupJapanTraditional), /// 180.39
                    sizes: [
                        .init(0.75, "bottle", .init(1.2)),
                        .init(1.5, "pack", .init(3, "bottle")),
                        .init(0.5, "box", .init(2, "pack"))
                    ]
                )
            ),
            equivalentSizes: [
                (nil, "bottle", 5.00964292),
                (nil, "pack", 2.50482146),
                (nil, "box", 0.62620537)
            ]
        ),
        
        /// Edge cases for a size with `serving` unit, where there is no serving but there is a size named "serving"
        FoodQuantityTestCase(
            quantity: FoodQuantity(
                100, .g,
                Food(
                    amount: .init(100, .g),
                    sizes: [
                        .init(1, "package", .init(4)),
                        .init(1, "serving", .init(30, .g))
                    ]
                )
            ),
            equivalentSizes: [
                (nil, "package", 0.83333333),
                (nil, "serving", 3.33333333),
            ]
        ),
        
        //TODO: Write tests for these later
        
        /// serving-based sizes with a weight-size-based serving

        /// serving-based sizes with a volume-size-based serving

        /// serving-based sizes with a volume-size-size-size-based serving

        /// serving-based sizes with a volume-prefixed-size-based serving

    ]
}
