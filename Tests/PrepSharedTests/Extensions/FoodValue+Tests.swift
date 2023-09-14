import PrepShared

public extension FoodValue {
    init(_ amount: Double, _ unit: WeightUnit) {
        self.init(.init(value: amount, unit: unit))
    }
    
    init(_ amount: Double, _ unit: VolumeUnit) {
        self.init(.init(value: amount, unit: unit))
    }
    
    init(_ amount: Double, _ sizeVolumeUnit: VolumeUnit? = nil, _ sizeID: String) {
        self.init(
            value: amount,
            unitType: .size,
            sizeID: sizeID,
            sizeVolumeUnit: sizeVolumeUnit
        )
    }

    init(_ amount: Double, _ sizeUnitId: String) {
        self.init(
            value: amount,
            unitType: .size,
            sizeID: sizeUnitId,
            sizeVolumeUnit: nil
        )
    }

    init(_ weight: WeightQuantity) {
        self.init(
            value: weight.value,
            unitType: .weight,
            weightUnit: weight.unit
        )
    }
    
    init(_ volume: VolumeQuantity) {
        self.init(
            value: volume.value,
            unitType: .volume,
            volumeUnit: volume.unit
        )
    }
    
    init(_ servings: Double) {
        self.init(
            value: servings,
            unitType: .serving
        )
    }
}
