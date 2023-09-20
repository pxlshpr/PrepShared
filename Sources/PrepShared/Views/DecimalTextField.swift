import SwiftUI

public struct DecimalTextField: View {

    let placeholder: String
    let roundUp: Bool
    let binding: Binding<Double>
    
    public init(
        placeholder: String = "",
        roundUp: Bool = false,
        binding: Binding<Double>
    ) {
        self.placeholder = placeholder
        self.roundUp = roundUp
        self.binding = binding
    }
    
    public var body: some View {
        TextField(
            placeholder,
            value: binding,
            formatter: roundUp ? NumberFormatter.energyValue : NumberFormatter.foodValue
        )
        .textFieldStyle(.plain)
        .multilineTextAlignment(.trailing)
        .keyboardType(roundUp ? .numberPad : .decimalPad)
        .simultaneousGesture(textSelectionTapGesture)
    }
}
