import SwiftUI

//public let NumberFont = Font.system(.body, design: .monospaced, weight: .bold)
public let NumberFont = Font.system(.body)

public struct NumberField: View {
    
    let placeholder: String
    
    let roundUp: Bool
    let doubleBinding: Binding<Double?>?
    
    let intBinding: Binding<Int?>?
    
    let isFocusedBinding: Binding<Bool>
    
    @State var includeTrailingPeriod: Bool = false
    @State var includeTrailingZero: Bool = false
    @State var numberOfTrailingZeros: Int = 0

    @FocusState var isFocused: Bool
    
    let onFocusLoss: (() -> ())?
    
    let font: Font?
    
    public init(
        placeholder: String = "",
        roundUp: Bool = false,
        binding: Binding<Double?>,
        isFocused: Binding<Bool>? = nil,
        font: Font? = nil,
        onFocusLoss: (() -> ())? = nil
    ) {
        self.placeholder = placeholder
        self.roundUp = roundUp
        self.doubleBinding = binding
        self.intBinding = nil
        self.isFocusedBinding = isFocused ?? .constant(false)
        self.font = font
        self.onFocusLoss = onFocusLoss
    }
    
    public init(
        placeholder: String = "",
        binding: Binding<Int?>,
        isFocused: Binding<Bool>? = nil,
        font: Font? = nil,
        onFocusLoss: (() -> ())? = nil
    ) {
        self.placeholder = placeholder
        self.roundUp = true
        self.intBinding = binding
        self.doubleBinding = nil
        self.isFocusedBinding = isFocused ?? .constant(false)
        self.font = font
        self.onFocusLoss = onFocusLoss
    }
    
    public var body: some View {
        textField
//            .focused($isFocused)
            .textFieldStyle(.plain)
            .font(font ?? NumberFont)
            .multilineTextAlignment(.trailing)
//            .toolbar { keyboardToolbarContent }
            .keyboardType(roundUp ? .numberPad : .decimalPad)
            .simultaneousGesture(textSelectionTapGesture)
//            .onChange(of: isFocusedBinding.wrappedValue, isFocusedBindingChanged)
//            .onChange(of: isFocused, isFocusedChanged)
    }

    func isFocusedChanged(old: Bool, new: Bool) {
        if new == false { onFocusLoss?() }
    }

    func isFocusedBindingChanged(old: Bool, new: Bool) {
        if new { isFocused = true }
    }
    
    var textField: some View {
        let textBinding = Binding<String>(
            get: {
                if let doubleBinding {
                    
                    var string: String
                    
                    if let value = doubleBinding.wrappedValue {
                        
                        if includeTrailingZero {
                            string = "0.0"
                        } else {
                            if roundUp {
                                let formatter = NumberFormatter.input(0)
                                let number = NSNumber(value: value)
                                string = formatter.string(from: number) ?? ""
                            } else {
                                string = "\(NSNumber(value: value).decimalValue)"
                            }
                        }
                        
                    } else {
                        string = ""
                    }
                    string = string + "\(includeTrailingPeriod ? "." : "")"
                    print("Returning \(string)")
                    return string
                } else if let intBinding, let value = intBinding.wrappedValue {
                    return "\(value)"
                } else {
                    return ""
                }
            },
            set: { newValue in
                if let doubleBinding {
                    
                    /// Cleanup by removing any extra periods and non-numbers
                    let newValue = newValue.sanitizedDouble
                    
                    print("newValue: \(newValue)")
                    /// If we haven't already set the flag for the trailing period, and the string has period as its last character, set it so that its displayed
                    if !includeTrailingPeriod, newValue.last == "." {
                        print("setting includeTrailingPeriod to true")
                        includeTrailingPeriod = true
                    } 
                    /// If we have set the flag for the trailing period and the last character isn't it—unset it
                    else if includeTrailingPeriod, newValue.last != "." {
                        print("setting includeTrailingPeriod to false")
                        includeTrailingPeriod = false
                    }
                    
                    if newValue == ".0" {
                        includeTrailingZero = true
                    } else {
                        includeTrailingZero = false
                    }
                    
                    let double = Double(newValue)
                    doubleBinding.wrappedValue = double
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



struct NumberFieldTest: View {
    
    @State var value: Double? = 500
    
    var body: some View {
        NavigationStack {
            Form {
                HStack {
                    Spacer()
                    NumberField(
                        placeholder: "Placeholder",
                        binding: $value
                    )
                }
            }
        }
    }
}

#Preview {
    NumberFieldTest()
}
