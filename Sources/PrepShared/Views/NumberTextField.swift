import SwiftUI

public struct NumberTextField: View {

    let placeholder: String
    
    let roundUp: Bool
    let doubleBinding: Binding<Double>?
    
    let intBinding: Binding<Int>?
    
    public init(
        placeholder: String = "",
        roundUp: Bool = false,
        binding: Binding<Double>
    ) {
        self.placeholder = placeholder
        self.roundUp = roundUp
        self.doubleBinding = binding
        self.intBinding = nil
    }

    public init(
        placeholder: String = "",
        binding: Binding<Int>
    ) {
        self.placeholder = placeholder
        self.roundUp = true
        self.intBinding = binding
        self.doubleBinding = nil
    }

    public var body: some View {
        textField
            .textFieldStyle(.plain)
            .multilineTextAlignment(.trailing)
            .keyboardType(roundUp ? .numberPad : .decimalPad)
            .simultaneousGesture(textSelectionTapGesture)
    }
    
    var textField: some View {
        if let doubleBinding {
            TextField(
                placeholder,
                value: doubleBinding,
                formatter: roundUp ? NumberFormatter.energyValue : NumberFormatter.foodValue
            )
        } else {
            TextField(
                placeholder,
                value: intBinding!,
                formatter: NumberFormatter.energyValue
            )
        }
    }
}
