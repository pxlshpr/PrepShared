import PrepShared

public extension Food {
    init(
        mockName name: String = "",
        emoji: String = "",
        detail: String? = nil,
        brand: String? = nil,
        amount: FoodValue = .init(1),
        serving: FoodValue? = nil,
        density: FoodDensity? = nil,
        sizes: [FoodSize] = []
    ) {
        let energy = Double.random(in: 30...500)
        let carb = Double.random(in: 0...100)
        let fat = Double.random(in: 0...100)
        let protein = Double.random(in: 0...100)
        
        self.init(
            emoji: emoji,
            name: name,
            detail: detail,
            brand: brand,
            amount: amount,
            serving: serving,
            energy: energy,
            energyUnit: .kcal,
            carb: carb,
            protein: protein,
            fat: fat,
            micros: [],
            sizes: sizes,
            density: density
        )
    }
}
