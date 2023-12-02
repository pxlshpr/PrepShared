import SwiftUI

//public let NumberFont = Font.system(.body, design: .monospaced, weight: .bold)
public let NumberFont = Font.system(.body)

public struct NumberTextField: View {

    let placeholder: String
    
    let roundUp: Bool
    let doubleBinding: Binding<Double>?
    
    let intBinding: Binding<Int>?
    
    let isFocusedBinding: Binding<Bool>
    
    @FocusState var isFocused: Bool
    
    public init(
        placeholder: String = "",
        roundUp: Bool = false,
        binding: Binding<Double>,
        isFocused: Binding<Bool>? = nil
    ) {
        self.placeholder = placeholder
        self.roundUp = roundUp
        self.doubleBinding = binding
        self.intBinding = nil
        self.isFocusedBinding = isFocused ?? .constant(false)
    }

    public init(
        placeholder: String = "",
        binding: Binding<Int>,
        isFocused: Binding<Bool>? = nil
    ) {
        self.placeholder = placeholder
        self.roundUp = true
        self.intBinding = binding
        self.doubleBinding = nil
        self.isFocusedBinding = isFocused ?? .constant(false)
    }

    public var body: some View {
        textField
            .focused($isFocused)
            .textFieldStyle(.plain)
            .font(NumberFont)
            .multilineTextAlignment(.trailing)
            .keyboardType(roundUp ? .numberPad : .decimalPad)
            .simultaneousGesture(textSelectionTapGesture)
            .onChange(of: isFocusedBinding.wrappedValue, isFocusedBindingChanged)
    }
    
    func isFocusedBindingChanged(old: Bool, new: Bool) {
        if new { isFocused = true }
    }
    
    @ViewBuilder
    var textField: some View {
        if let doubleBinding {
            TextField(
                placeholder,
                value: doubleBinding,
//                formatter: NumberFormatter.input(roundUp ? 0 : 2)
                format: .number
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

struct NumberTextFieldTest: View {
    @State var value: Int = 0
    var body: some View {
        NavigationStack {
            Form {
                HStack {
                    Spacer()
                    NumberTextField(
                        placeholder: "Placeholder",
                        binding: $value
                    )
                }
            }
        }
    }
}

#Preview {
    NumberTextFieldTest()
}
