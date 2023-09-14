import XCTest
@testable import PrepShared
@testable import SwiftSugar

final class FoodServingsTests: XCTestCase {

    func testWeight() throws {
        let food = Food(
            serving: .init(0.282192, .oz), /// 8g
            sizes: [
                .init(3, "ball", .init(12, .g)),        /// 4g
                .init(1.5, "box", .init(30, "ball")),   /// 20 balls = 80 g
                .init(5, "carton", .init(15, "box")),   /// 3 boxes = 60 balls = 240g
            ]
        )

        let expectations: [String: Double] = [
            "ball": 2,
            "box": 0.1,
            "carton": 0.03333333
        ]

        for (sizeId, expectedServings) in expectations {
            guard let servings = food.quantityInOneServing(of: sizeId) else {
                XCTFail()
                return
            }
            assertEqual(servings, expectedServings)
        }
    }

    func testVolume() throws {
        let food = Food(
            serving: .init(0.25, .cupJapanTraditional),                         /// 0.25 x 180.39 mL =  45.0975 mL
            sizes: [
                .init(1.5, "bottle", .init(6, .fluidOunceUSNutritionLabeling)), /// 1 bottle =  120 mL
                .init(2, "pack", .init(4, "bottle")),                           /// 1 pack = 240 mL
                .init(0.5, "box", .init(6, "pack")),                            /// 1 box = 2880 mL
            ]
        )

        let expectations: [String: Double] = [
            "bottle": 0.3758125,
            "pack": 0.18790625,
            "box": 0.01565885
        ]

        for (sizeId, expectedServings) in expectations {
            guard let servings = food.quantityInOneServing(of: sizeId) else {
                XCTFail()
                return
            }
            assertEqual(servings, expectedServings)
        }
    }

    func testWeightBasedSize() throws {
        let food = Food(
            serving: .init(2, "ball"),
            sizes: [
                .init(3, "ball", .init(12, .g)),        /// 4g
                .init(1.5, "box", .init(30, "ball")),   /// 20 balls
                .init(5, "carton", .init(15, "box")),   /// 3 boxes = 60 balls
            ]
        )

        let expectations: [String: Double] = [
            "ball": 2,
            "box": 0.1,
            "carton": 0.03333333
        ]

        for (sizeId, expectedServings) in expectations {
            guard let servings = food.quantityInOneServing(of: sizeId) else {
                XCTFail()
                return
            }
            assertEqual(servings, expectedServings)
        }
    }

    /// weight-based-size-based size
    func testWeightBasedSizeBasedSize() throws {
        let food = Food(
            serving: .init(1.5, "box"),
            sizes: [
                .init(3, "ball", .init(12, .g)),        /// 4g
                .init(1.5, "box", .init(30, "ball")),   /// 20 balls
                .init(5, "carton", .init(15, "box")),   /// 3 boxes = 60 balls
            ]
        )

        let expectations: [String: Double] = [
            "ball": 30,
            "box": 1.5,
            "carton": 0.5
        ]

        for (sizeId, expectedServings) in expectations {
            guard let servings = food.quantityInOneServing(of: sizeId) else {
                XCTFail()
                return
            }
            assertEqual(servings, expectedServings)
        }
    }

    /// volume-prefixed-size-based-size
    func testVolumePrefixedWeightBasedSizeBasedSize1() throws {
        let food = Food(
            serving: .init(1, .cupJapanTraditional, "chopped4"), /// 180.39 mL
            sizes: [
                .init(2, .cupJapanTraditional, "chopped", .init(370, .g)), /// 30 mL
                .init(1.5, "packet", .init(3, "chopped4")), /// 2 chopped
                .init(5, "carton", .init(15, "packet")) /// 3 packets
            ]
        )

        let expectedSizes: [(VolumeUnit?, String, Double)] = [
            (.cupJapanTraditional, "chopped4", 1), /// 180.39 mL
            (.fluidOunceUSNutritionLabeling, "chopped4", 6.013),
            (nil, "carton", 0.16666667)
        ]

        for sizeTest in expectedSizes {

            let volumePrefixUnit = sizeTest.0
            let sizeId = sizeTest.1
            let expectedValue = sizeTest.2

            guard let servings = food.quantityInOneServing(of: sizeId, with: volumePrefixUnit) else {
                XCTFail()
                return
            }
            assertEqual(servings, expectedValue)
        }
    }

    func testVolumePrefixedWeightBasedSizeBasedSize() throws {
        let food = Food(
            serving: .init(1, .cupJapanTraditional, "chopped5"), /// 180.39 mL
            sizes: [
                .init(2, .fluidOunceUSNutritionLabeling, "chopped", .init(370, .g)), /// 30 mL
                .init(1.5, "packet", .init(3, "chopped5")), /// 2 chopped
                .init(5, "carton", .init(15, "packet")) /// 3 packet
            ]
        )

        let expectedSizes: [(VolumeUnit?, String, Double)] = [
            (.cupJapanTraditional, "chopped5", 1), /// 180.39 mL
            (.fluidOunceUSNutritionLabeling, "chopped5", 6.013),
            (nil, "carton", 1.00216667)
        ]

        for sizeTest in expectedSizes {

            let volumePrefixUnit = sizeTest.0
            let sizeId = sizeTest.1
            let expectedValue = sizeTest.2

            guard let servings = food.quantityInOneServing(of: sizeId, with: volumePrefixUnit) else {
                XCTFail()
                return
            }
            assertEqual(servings, expectedValue)
        }
    }

    /// volume-based-size
    func testVolumeBasedSize() throws {
        let food = Food(
            serving: .init(2, "bottle"),
            sizes: [
                .init(2, "bottle", .init(3.5, .cupMetric)), /// 250 mL
                .init(1.5, "box", .init(30, "bottle")), /// 20 bottles
                .init(5, "carton", .init(15, "box")),   /// 3 boxes
            ]
        )


        let expectedServings: [String: Double] = [
            "bottle": 2,
            "box": 0.1,
            "carton": 0.03333333
        ]

        for (sizeId, expectedServing) in expectedServings {
            guard let servings = food.quantityInOneServing(of: sizeId) else {
                XCTFail()
                return
            }
            assertEqual(servings, expectedServing)
        }
    }

    /// volume-based-size-based size
    func testVolumeBasedSizeBasedSize() throws {
        let food = Food(
            serving: .init(1.5, "box"),
            sizes: [
                .init(2, "bottle", .init(3.5, .cupMetric)), /// 250 mL
                .init(1.5, "box", .init(30, "bottle")), /// 20 bottles
                .init(5, "carton", .init(15, "box")),   /// 3 boxes
            ]
        )

        let expectations: [String: Double] = [
            "bottle": 30,
            "box": 1.5,
            "carton": 0.5
        ]

        for (sizeId, expectedServings) in expectations {
            guard let servings = food.quantityInOneServing(of: sizeId) else {
                XCTFail()
                return
            }
            assertEqual(servings, expectedServings)
        }
    }

    /// serving-based-size based size
    func testServingBasedSizeBasedSize() throws {
        let food = Food(
            serving: .init(4, "bottle"),
            sizes: [
                .init(2, "bottle", .init(1)),
                .init(1.5, "box", .init(30, "bottle")), /// 20 bottles
                .init(5, "carton", .init(15, "box")),   /// 3 boxes
            ]
        )

        let expectations: [String: Double] = [
            "bottle": 4,
            "box": 0.2,
            "carton": 0.06666667
        ]

        for (sizeId, expectedServings) in expectations {
            guard let servings = food.quantityInOneServing(of: sizeId) else {
                XCTFail()
                return
            }
            assertEqual(servings, expectedServings)
        }
    }

    /// serving-based-size-based-size based size
    func testServingBasedSizeBasedSizeBasedSize() throws {
        let food = Food(
            serving: .init(10, "box"),
            sizes: [
                .init(2, "bottle", .init(1)),
                .init(1.5, "box", .init(30, "bottle")), /// 20 bottles
                .init(5, "carton", .init(15, "box")),   /// 3 boxes
            ]
        )

        let expectations: [String: Double] = [
            "bottle": 200,
            "box": 10,
            "carton": 3.33333333
        ]

        for (sizeId, expectedServings) in expectations {
            guard let servings = food.quantityInOneServing(of: sizeId) else {
                XCTFail()
                return
            }
            assertEqual(servings, expectedServings)
        }
    }
}
