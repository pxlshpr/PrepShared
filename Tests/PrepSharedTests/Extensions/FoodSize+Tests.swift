import PrepShared

public extension FoodSize {
    
    init(name: String, volumeUnit: VolumeUnit? = nil, quantity: Double, value: FoodValue) {
        self.init(
            quantity: quantity,
            name: name,
            volumeUnit: volumeUnit,
            value: value
        )
    }

    init(_ quantity: Double, _ name: String, _ value: FoodValue) {
        self.init(
            quantity: quantity,
            name: name,
            volumeUnit: nil,
            value: value
        )
    }

    init(_ quantity: Double, _ volumeUnit: VolumeUnit?, _ name: String, _ value: FoodValue) {
        self.init(
            quantity: quantity,
            name: name,
            volumeUnit: volumeUnit,
            value: value
        )
    }
}
