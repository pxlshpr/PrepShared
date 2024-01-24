import SwiftUI

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

