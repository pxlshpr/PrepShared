import SwiftUI

public let HealthFont = Font.system(.body, design: .monospaced, weight: .bold)

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
            .font(HealthFont)
            .multilineTextAlignment(.trailing)
            .keyboardType(roundUp ? .numberPad : .decimalPad)
            .simultaneousGesture(textSelectionTapGesture)
    }
    
    @ViewBuilder
    var textField: some View {
        if let doubleBinding {
            TextField(
                placeholder,
                value: doubleBinding,
                formatter: NumberFormatter.input(roundUp ? 0 : 2)
            )
            .contentTransition(.numericText(value: doubleBinding.wrappedValue))
            .animation(.default, value: doubleBinding.wrappedValue)
        } else if let intBinding {
            TextField(
                placeholder,
                value: intBinding,
                formatter: NumberFormatter.input(0)
            )
            .contentTransition(.numericText(value: Double(intBinding.wrappedValue)))
            .animation(.default, value: intBinding.wrappedValue)
        }
    }
}
