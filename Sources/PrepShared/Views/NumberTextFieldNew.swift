import SwiftUI

public struct NumberTextFieldNew: View {
    
    let placeholder: String
    
    let roundUp: Bool
    let doubleBinding: Binding<Double?>?
    
    let intBinding: Binding<Int?>?
    
    let isFocusedBinding: Binding<Bool>
    
    @FocusState var isFocused: Bool
    
    public init(
        placeholder: String = "",
        roundUp: Bool = false,
        binding: Binding<Double?>,
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
        binding: Binding<Int?>,
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
            .toolbar { keyboardToolbarContent }
            .keyboardType(roundUp ? .numberPad : .decimalPad)
            .simultaneousGesture(textSelectionTapGesture)
            .onChange(of: isFocusedBinding.wrappedValue, isFocusedBindingChanged)
    }
    
    func isFocusedBindingChanged(old: Bool, new: Bool) {
        if new { isFocused = true }
    }
    
    var textField: some View {
        let textBinding = Binding<String>(
            get: {
                if let doubleBinding, let value = doubleBinding.wrappedValue {
                    let formatter = NumberFormatter.input(roundUp ? 0 : 2)
                    return formatter.string(from: NSNumber(value: value)) ?? ""
                } else if let intBinding, let value = intBinding.wrappedValue {
                    return "\(value)"
                } else {
                    return ""
                }
            },
            set: { newValue in
                if let doubleBinding {
                    doubleBinding.wrappedValue = Double(newValue)
                } else if let intBinding {
                    intBinding.wrappedValue = Int(newValue)
                }
            }
        )
        
        return TextField("", text: textBinding)
    }
    
    var keyboardToolbarContent: some ToolbarContent {
        ToolbarItemGroup(placement: .keyboard) {
            HStack {
                Spacer()
                Button("Done") {
                    isFocused = false
                }
                .fontWeight(.semibold)
            }
        }
    }
}


struct NumberTextFieldTest: View {
    
    @State var value: Double? = 500
    
    var body: some View {
        NavigationStack {
            Form {
                HStack {
                    Spacer()
                    NumberTextFieldNew(
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
