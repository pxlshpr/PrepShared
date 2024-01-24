import SwiftUI
import SwiftUIIntrospect

public struct IntTextField: View {
    
    @Binding var intInput: DoubleInput
    @Binding var hasFocused: Bool
    let placeholder: String
    let delayFocus: Bool
    let handleChanges: () -> ()
    let handleLostFocus: (() -> ())?

    @FocusState var focused: Bool

    public init(
        intInput: Binding<DoubleInput>,
        placeholder: String = "",
        hasFocused: Binding<Bool>,
        delayFocus: Bool = false,
        handleChanges: @escaping () -> (),
        handleLostFocus: (() -> ())? = nil
    ) {
        _intInput = intInput
        _hasFocused = hasFocused
        self.placeholder = placeholder
        self.delayFocus = delayFocus
        self.handleChanges = handleChanges
        self.handleLostFocus = handleLostFocus
    }
    
    public var body: some View {
        TextField(placeholder, text: binding)
            .keyboardType(.numberPad)
            .multilineTextAlignment(.trailing)
            .simultaneousGesture(textSelectionTapGesture)
            .introspect(.textField, on: .iOS(.v17)) { introspect($0) }
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
            get: { intInput.binding.wrappedValue },
            set: { newValue in
                intInput.binding.wrappedValue = newValue
                handleChanges()
            }
        )
    }
    
    func introspect(_ textField: UITextField) {
        guard !hasFocused else { return }
        hasFocused = true

        let deadline: DispatchTime = .now() + (delayFocus ? DefaultFocusDelay : 0)
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            textField.becomeFirstResponder()
            textField.selectedTextRange = textField.textRange(
                from: textField.beginningOfDocument,
                to: textField.endOfDocument
            )
        }
    }
}
