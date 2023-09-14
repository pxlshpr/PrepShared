import PrepShared

public extension FoodDensity {
    init(_ weightAmount: Double, _ weightUnit: WeightUnit, _ volumeAmount: Double, _ volumeUnit: VolumeUnit) {
        self.init(
            weightAmount: weightAmount,
            weightUnit: weightUnit,
            volumeAmount: volumeAmount,
            volumeUnit: volumeUnit
        )
    }
}
