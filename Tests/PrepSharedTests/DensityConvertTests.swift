import XCTest
@testable import PrepShared
@testable import SwiftSugar

final class DensityConvertTests: XCTestCase {
    
    func testWeightToVolume1() throws {
        let density = FoodDensity(weightAmount: 100, weightUnit: .g,
                                  volumeAmount: 1, volumeUnit: .cupMetric)
        
        let testCases: [WeightQuantity: VolumeQuantity] = [
            .init(value: 100, unit: .g): .init(value: 1, unit: .cupMetric),
            .init(value: 200, unit: .g): .init(value: 2, unit: .cupMetric),
            .init(value: 5.29109, unit: .oz): .init(value: 1.5, unit: .cupMetric)
        ]
        
        for (weight, expectedVolume) in testCases {
            let volume = density.convert(weight: weight)
            XCTAssertEqual(volume, expectedVolume)
        }
    }

    func testWeightToVolume2() throws {
        let density = FoodDensity(weightAmount: 25, weightUnit: .oz,
                                  volumeAmount: 13, volumeUnit: .tablespoonMetric)
        let testCases: [WeightQuantity: VolumeQuantity] = [
            .init(value: 100, unit: .g): .init(value: 1.834248, unit: .tablespoonMetric)
        ]
        
        for (weight, expectedVolume) in testCases {
            let volume = density.convert(weight: weight)
            XCTAssertEqual(volume, expectedVolume)
        }
    }

    func testVolumeToWeight1() throws {
        let density = FoodDensity(weightAmount: 100, weightUnit: .g,
                                  volumeAmount: 1, volumeUnit: .cupMetric)
        
        let testCases: [VolumeQuantity: WeightQuantity] = [
            .init(value: 1, unit: .cupMetric): .init(value: 100, unit: .g),
            .init(value: 15, unit: .tablespoonUS): .init(value: 88.74, unit: .g),
        ]
        
        for (volume, expectedWeight) in testCases {
            let weight = density.convert(volume: volume)
            XCTAssertEqual(weight, expectedWeight)
        }
    }
    
    func testVolumeToWeight2() throws {
        let density = FoodDensity(weightAmount: 17.56, weightUnit: .oz,
                                  volumeAmount: 0.25, volumeUnit: .pintUSLiquid)
        
        
        let testCases: [VolumeQuantity: WeightQuantity] = [
            .init(value: 2.2, unit: .cupJapanTraditional): .init(value: 58.91, unit: .oz),
        ]
        
        for (volume, expectedWeight) in testCases {
            let weight = density.convert(volume: volume)
            XCTAssertEqual(weight, expectedWeight)
        }
    }
}
