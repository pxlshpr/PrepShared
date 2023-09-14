import XCTest
@testable import PrepShared
@testable import SwiftSugar

final class FoodQuantityConvertMiscTests: XCTestCase {
    
    func testUnitSizes() throws {
        let food = Food(
            mockName: "Spinach",
            serving: .init(1, .cupMetric),
            density: .init(30, .g, 1, .cupMetric),
            sizes: [
                .init(1, "leaf", .init(10, .g)),
            ]
        )
        
        
        guard let oneLeaf = FoodQuantity(1, "leaf", food) else { XCTFail(); return }
        guard let servings = oneLeaf.convert(to: .serving) else { XCTFail(); return }
        assertEqual(servings.value, 0.3333)
        
        let oneServing = FoodQuantity(1, food)
        guard let leaf = food.quantitySize(for: "leaf") else { XCTFail(); return }
        guard let leaves = oneServing.convert(to: .size(leaf, nil)) else { XCTFail(); return }
        assertEqual(leaves.value, 3)

//        cprint("We're here")
    }
}
