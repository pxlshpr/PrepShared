import XCTest
@testable import PrepShared
@testable import SwiftSugar

final class TestsInbox: XCTestCase {

    let food = Food(
        mockName: "Carrot",
        serving: .init(1, .cupUSLegal, "chopped4"), /// 240 mL
        sizes: [
            .init(0.5, .cupUSLegal, "chopped", .init(135, .g)), /// 240 mL
            .init(2, "medium", .init(100, .g)),
        ]
    )
    
    func test1() throws {
        let quantity = FoodQuantity(1, food)
        guard let choppedUS = food.quantitySize(for: "chopped4") else { XCTFail(); return }
        let choppedMetricUnit = FoodQuantity.Unit.size(choppedUS, .cupMetric)
        guard let convertedQuantity = quantity.convert(to: choppedMetricUnit) else { XCTFail(); return }
        assertEqual(convertedQuantity.value, 0.96)
    }

    func test2() throws {
        let quantity = FoodQuantity(1, .cupMetric, "chopped4", food)!
        guard let choppedUS = food.quantitySize(for: "chopped4") else { XCTFail(); return }
        let choppedMetricUnit = FoodQuantity.Unit.size(choppedUS, .cupMetric)
        guard let convertedQuantity = quantity.convert(to: choppedMetricUnit) else { XCTFail(); return }
        assertEqual(convertedQuantity.value, 1)
    }
}
