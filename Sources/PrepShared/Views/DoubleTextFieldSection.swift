import SwiftUI
import SwiftUIIntrospect

public struct DoubleTextField: View {
    
    @Binding var doubleInput: DoubleInput
    @Binding var hasFocused: Bool
    @Binding var focusDelay: Double
    let delayFocus: Bool
    let handleChanges: () -> ()
    let handleLostFocus: (() -> ())?

    @FocusState var focused: Bool

    public init(
        doubleInput: Binding<DoubleInput>,
        hasFocused: Binding<Bool>,
        delayFocus: Bool = false,
        focusDelay: Binding<Double> = .constant(0.05),
        handleChanges: @escaping () -> (),
        handleLostFocus: (() -> ())? = nil
    ) {
        _focusDelay = focusDelay
        _doubleInput = doubleInput
        _hasFocused = hasFocused
        self.delayFocus = delayFocus
        self.handleChanges = handleChanges
        self.handleLostFocus = handleLostFocus
    }
    
    public var body: some View {
        TextField("", text: binding)
            .keyboardType(.decimalPad)
            .multilineTextAlignment(.trailing)
            .introspect(.textField, on: .iOS(.v17)) { introspect($0) }
            .simultaneousGesture(textSelectionTapGesture)
            .foregroundStyle(.primary)
            .focused($focused)
            .onChange(of: focused) { oldValue, newValue in
                if !newValue {
                    handleLostFocus?()
                }
            }
    }
    
    var binding: Binding<String> {
        Binding<String>(
            get: { doubleInput.binding.wrappedValue },
            set: { newValue in
                doubleInput.binding.wrappedValue = newValue
                handleChanges()
            }
        )
    }
    
    func introspect(_ textField: UITextField) {
        guard !hasFocused else { return }
        hasFocused = true

        let deadline: DispatchTime = .now() + (delayFocus ? focusDelay : 0)
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            textField.becomeFirstResponder()
            textField.selectedTextRange = textField.textRange(
                from: textField.beginningOfDocument,
                to: textField.endOfDocument
            )
        }
    }
}

public struct DoubleTextFieldSection: View {
    
    let title: String
    let footerString: String?
    
    @Binding var doubleInput: DoubleInput
    @Binding var hasFocused: Bool
    @Binding var focusDelay: Double
    let delayFocus: Bool
    let handleChanges: () -> ()
    let handleLostFocus: (() -> ())?
    
    @FocusState var focused: Bool
    
    public init(
        title: String,
        doubleInput: Binding<DoubleInput>,
        hasFocused: Binding<Bool>,
        delayFocus: Bool = false,
        focusDelay: Binding<Double> = .constant(0.05),
        footer: String? = nil,
        handleChanges: @escaping () -> (),
        handleLostFocus: (() -> ())? = nil
    ) {
        self.title = title
        _focusDelay = focusDelay
        _doubleInput = doubleInput
        _hasFocused = hasFocused
        self.delayFocus = delayFocus
        self.footerString = footer
        self.handleChanges = handleChanges
        self.handleLostFocus = handleLostFocus
    }
    
    public var body: some View {
        Section(footer: footer) {
            HStack {
                Text(title)
                    .foregroundStyle(.primary)
                Spacer()
                DoubleTextField(
                    doubleInput: $doubleInput,
                    hasFocused: $hasFocused,
                    delayFocus: delayFocus,
                    focusDelay: $focusDelay,
                    handleChanges: handleChanges,
                    handleLostFocus: handleLostFocus
                )
            }
        }
    }
    
    @ViewBuilder
    var footer: some View {
        if let footerString {
            Text(footerString)
        }
    }

}

