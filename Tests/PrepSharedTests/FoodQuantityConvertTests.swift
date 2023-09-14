import XCTest
@testable import PrepShared
@testable import SwiftSugar

final class FoodQuantityConvertTests: XCTestCase {
}

struct FoodQuantityTestCase {
    let quantity: FoodQuantity
    var equivalentWeights: [WeightUnit: Double] = [:]
    var equivalentVolumes: [VolumeUnit: Double] = [:]
    var equivalentServing: Double? = nil
    var equivalentSizes: [(VolumeUnit?, String, Double)] = []
}

struct TestCases {
}

func assertEqual(toPlaces places: Int = 2, _ double: Double, _ other: Double) {
    XCTAssertEqual(double.rounded(toPlaces: places), other.rounded(toPlaces: places))
}
