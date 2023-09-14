import XCTest
@testable import PrepShared
@testable import SwiftSugar

final class FoodQuantitySizeTests: XCTestCase {
    
    func testUnitWeight() throws {
        let food = Food(
            serving: .init(1.5, "carton"),
            sizes: [
                .init(name: "ball", quantity: 3, value: .init(12, .g)),
                .init(name: "box", quantity: 1.5, value: .init(30, "ball")),
                .init(name: "carton", quantity: 5, value: .init(15, "box")),
            ]
        )
        
        let testCases: [String: WeightQuantity] = [
            "ball": .init(4, .g),
            "box": .init(80, .g),
            "carton": .init(240, .g)
        ]
        
        for (sizeId, expectedUnitWeight) in testCases {
            guard let size = food.quantitySize(for: sizeId),
                  let unitWeight = size.unitWeight(in: food)
            else {
                XCTFail()
                return
            }
            
            XCTAssertEqual(unitWeight, expectedUnitWeight)
        }
    }
}
