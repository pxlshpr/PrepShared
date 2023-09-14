import XCTest
@testable import PrepShared
@testable import SwiftSugar

extension FoodQuantityConvertTests {
    
    func test_Size_Weight() throws {
        for testCase in TestCases.Size_Weight {
            
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
    
    static let Size_Weight = [
        
        /// volumeprefixedsize
        FoodQuantityTestCase(
            quantity: FoodQuantity(
                1.25, .tablespoonUS, "chopped4", /// 14.79
                Food(
                    sizes: [
                        .init(1.5, .cupUSCustomary, "chopped", .init(270, .g)), /// 236.59
                    ]
                )
            )!,
            equivalentWeights: [
                .g : 14.065471913437,
                .oz : 0.4961449210774687
            ]
        ),

        /// weight-size
        FoodQuantityTestCase(
            quantity: FoodQuantity(
                1, "scoop",
                Food(
                    sizes: [
                        .init(2, "scoop", .init(60.8, .g)),
                    ]
                )
            )!,
            equivalentWeights: [
                .g : 30.4,
                .oz : 1.072328
            ]
        ),

        /// volume-size with density
        FoodQuantityTestCase(
            quantity: FoodQuantity(
                3, "bottle",
                Food(
                    density: .init(100, .g, 50, .mL),
                    sizes: [
                        .init(1.5, "bottle", .init(335, .mL)),
                    ]
                )
            )!,
            equivalentWeights: [
                .g : 1339.99999998
            ]
        ),
//        FoodQuantityTestCase(
//            quantity: FoodQuantity(
//                amount: 100,
//                unit: .weight(.g),
//                food: Food(density: FoodDensity(100, .g, 1, .cupMetric))
//            ),
//            explicitVolumeUnits: .defaultUnits,
//            equivalentVolumes: [
//                .cup : 1,
//            ]
//        ),
//        FoodQuantityTestCase(
//            quantity: FoodQuantity(
//                amount: 100,
//                unit: .weight(.g),
//                food: Food(density: FoodDensity(100, .g, 1, .cupMetric)) /// 250 ml
//            ),
//            explicitVolumeUnits: UserExplicitVolumeUnits(
//                cup: .cupJapanTraditional,   /// 180.39 ml
//                tablespoon: .tablespoonUS   /// 14.79 ml
//            ),
//            equivalentVolumes: [
//                .cup : 1.38588614,
//                .tablespoon: 16.90331305
//            ]
//        ),
//        FoodQuantityTestCase(
//            quantity: FoodQuantity(
//                amount: 50,
//                unit: .weight(.g),
//                food: Food(density: FoodDensity(100, .g, 1, .cupMetric)) /// 250 ml
//            ),
//            explicitVolumeUnits: UserExplicitVolumeUnits(
//                cup: .cupJapanTraditional,   /// 180.39 ml
//                tablespoon: .tablespoonUS   /// 14.79 ml
//            ),
//            equivalentVolumes: [
//                .cup : 0.69294307,
//                .tablespoon: 8.45165652
//            ]
//        )
//
    ]
}

