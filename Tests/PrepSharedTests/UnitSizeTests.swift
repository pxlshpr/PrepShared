import XCTest
@testable import PrepShared
@testable import SwiftSugar

final class UnitSizeTests: XCTestCase {
    
    func testUnitSizes() throws {
        let food = Food(
            serving: .init(2, "ball"),
            sizes: [
                .init(3, "ball", .init(12, .g)),            /// 4g
                .init(1.5, "box", .init(30, "ball")),       /// 20 balls
                .init(5, "carton", .init(15, "box")),       /// 3 boxes = 60 balls
                .init(2, "pellet", .init(12, "carton")),    /// 6 cartons = 18 boxes = 360 balls
            ]
        )
        
        let expectations: [String: Double] = [
            "box": 0.05,
            "carton": 0.01666667,
            "pellet": 0.00277778
        ]
        
        for (sizeId, expectedUnitSize) in expectations {
            guard let servingSize = food.servingSizeQuantity?.size else { XCTFail(); return }
            guard let size = food.quantitySize(for: sizeId) else { XCTFail(); return }
            guard let servings = servingSize.quantityPerSize(of: size, in: food) else { XCTFail(); return }
            assertEqual(toPlaces: 4, servings, expectedUnitSize)
        }
    }
    
    func testUnitSizes2() throws {
        let food = Food(
            serving: .init(1, "box"),
            sizes: [
                .init(3, "ball", .init(12, .g)),            /// 4g
                .init(1.5, "box", .init(30, "ball")),       /// 20 balls
                .init(5, "carton", .init(15, "box")),       /// 3 boxes = 60 balls
                .init(2, "pellet", .init(12, "carton")),    /// 6 cartons = 18 boxes = 360 balls
            ]
        )
        
        let expectations: [String: Double] = [
            "ball": 0.05,
        ]
        
        for (sizeId, expectedUnitSize) in expectations {
            guard let servingSize = food.servingSizeQuantity?.size else { XCTFail(); return }
            guard let size = food.quantitySize(for: sizeId) else { XCTFail(); return }
            guard let servings = size.quantityPerSize(of: servingSize, in: food) else { XCTFail(); return }
            assertEqual(toPlaces: 4, servings, expectedUnitSize)
        }
    }

}
