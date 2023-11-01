import SwiftUI

public struct UnitPicker: View {
    
    let nutrient: Nutrient
    @Binding var unit: NutrientUnit
    
    public init(nutrient: Nutrient, unit: Binding<NutrientUnit>) {
        self.nutrient = nutrient
        _unit = unit
    }

    @ViewBuilder
    public var body: some View {
        if nutrient.isEnergy {
            unitPickerForEnergy
        } else if let micro = nutrient.micro {
            if micro.goalUnits.count > 1 {
                unitPicker(for: micro)
            } else {
                unitText(micro.goalUnits.first?.abbreviation ?? "g")
            }
        } else {
            unitText("g")
        }
    }
    
    func unitText(_ string: String) -> some View {
        Text(string)
            .foregroundStyle(Color(.secondaryLabel))
            .padding(.horizontal, 5)
            .padding(.vertical, 3)
    }
    
    var unitPickerForEnergy: some View {
        unitPicker(for: nil)
    }

    @ViewBuilder
    func unitPicker(for micro: Micro?) -> some View {
        if let micro {
            MenuPicker<NutrientUnit>(micro.goalUnits, binding)
        } else {
            MenuPicker<NutrientUnit>([NutrientUnit.kcal, NutrientUnit.kJ], binding)
        }
    }
    
    var binding: Binding<NutrientUnit> {
        Binding<NutrientUnit>(
            get: { unit },
            set: { newUnit in
                withAnimation(.snappy) {
                    unit = newUnit
                }
            }
        )
    }
}
