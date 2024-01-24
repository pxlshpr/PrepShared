import SwiftUI
import SwiftUIIntrospect

public let DefaultFocusDelay: Double = 0.05

public struct DoubleTextField: View {
    
    @Binding var doubleInput: DoubleInput
    @Binding var hasFocused: Bool
    let placeholder: String
    let delayFocus: Bool
    let handleChanges: () -> ()
    let handleLostFocus: (() -> ())?

    @FocusState var focused: Bool

    public init(
        doubleInput: Binding<DoubleInput>,
        placeholder: String = "",
        hasFocused: Binding<Bool>,
        delayFocus: Bool = false,
        handleChanges: @escaping () -> (),
        handleLostFocus: (() -> ())? = nil
    ) {
        _doubleInput = doubleInput
        _hasFocused = hasFocused
        self.placeholder = placeholder
        self.delayFocus = delayFocus
        self.handleChanges = handleChanges
        self.handleLostFocus = handleLostFocus
    }
    
    public var body: some View {
        TextField(placeholder, text: binding)
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
