import SwiftUI
import SwiftHaptics

public var textSelectionTapGesture: some Gesture {
    TapGesture().onEnded {
        Haptics.selectionFeedback()
        DispatchQueue.main.async {
            sendSelectAllTextAction()
        }
    }
}

public func sendSelectAllTextAction() {
    UIApplication.shared.sendAction(#selector(UIResponder.selectAll),
        to: nil, from: nil, for: nil
    )
}
