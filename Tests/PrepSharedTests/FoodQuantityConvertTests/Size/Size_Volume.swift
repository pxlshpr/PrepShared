import XCTest
@testable import PrepShared
@testable import SwiftSugar

extension FoodQuantityConvertTests {
    
    func test_Size_Volume() throws {
        for testCase in TestCases.Size_Volume {
            
            for (volumeUnit, expectedVolume) in testCase.equivalentVolumes {
                guard let volume = testCase.quantity.convert(to: .volume(volumeUnit)) else {
                    XCTFail()
                    return
                }
                assertEqual(volume.value, expectedVolume)
            }
        }
    }
}

extension TestCases {
    
    static let Size_Volume = [
        
        /// volume-size with density
        FoodQuantityTestCase(
            quantity: FoodQuantity(
                3, "bottle",
                Food(
                    sizes: [
                        .init(1.5, "bottle", .init(335, .mL)),
                    ]
                )
            )!,
            equivalentVolumes: [
                .mL : 669.99999999,
                .tablespoonUS: 45.30087897
            ]
        ),
        
        //TODO: Convert these
//        /// volumeprefixedsize
//        FoodQuantityTestCase(
//            quantity: FoodQuantity(
//                1.25, .tablespoonUS, "chopped4", /// 14.79
//                Food(
//                    sizes: [
//                        .init(1.5, .cupUSCustomary, "chopped", .init(270, .g)), /// 236.59
//                    ]
//                )
//            )!,
//            equivalentWeights: [
//                .g : 14.065471913437,
//                .oz : 0.4961449210774687
//            ]
//        ),
//
//        /// weight-size
//        FoodQuantityTestCase(
//            quantity: FoodQuantity(
//                1, "scoop",
//                Food(
//                    sizes: [
//                        .init(2, "scoop", .init(60.8, .g)),
//                    ]
//                )
//            )!,
//            equivalentWeights: [
//                .g : 30.4,
//                .oz : 1.072328
//            ]
//        ),
    ]
}

