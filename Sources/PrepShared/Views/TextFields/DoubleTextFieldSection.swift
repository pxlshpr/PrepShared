import SwiftUI

public struct DoubleTextFieldSection: View {
    
    let title: String
    let footerString: String?
    
    @Binding var doubleInput: DoubleInput
    @Binding var hasFocused: Bool
    let delayFocus: Bool
    let handleChanges: () -> ()
    let handleLostFocus: (() -> ())?
    
    @FocusState var focused: Bool
    
    public init(
        title: String,
        doubleInput: Binding<DoubleInput>,
        hasFocused: Binding<Bool>,
        delayFocus: Bool = false,
        footer: String? = nil,
        handleChanges: @escaping () -> (),
        handleLostFocus: (() -> ())? = nil
    ) {
        self.title = title
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
