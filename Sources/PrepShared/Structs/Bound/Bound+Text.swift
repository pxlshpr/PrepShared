import SwiftUI
import SwiftSugar

//public let DefaultGoalBoundFormatter: ((Double) -> (String)) = { "\($0.cleanAmount)" }

//let DefaultBoundNumberFont: Font = .system(.body, design: .monospaced, weight: .bold)
public let DefaultBoundNumberFont: Font = .system(.body)

/// -[ ] In Prep, make sure we're placing it in an HStack to account for removing the maxWidth frame modifier
public extension Bound {
    func text(
        foregroundStyle: some ShapeStyle = Color(.label),
        font: Font = DefaultBoundNumberFont,
        formatter: (Double) -> (String) = { "\($0.cleanAmount)" },
        allowZeroLowerBound: Bool = false,
        unitString: String? = nil,
        emptyView: some View = EmptyView()
    ) -> some View {
        
        func valueText(_ value: Double, _ withUnit: Bool) -> some View {
            HStack(alignment: .firstTextBaseline, spacing: 3) {
                Text("\(formatter(value))")
                    .font(font)
                    .animation(.default, value: value)
                    .contentTransition(.numericText(value: value))
                    .foregroundStyle(foregroundStyle)
                if withUnit, let unitString {
                    text(unitString)
                }
            }
        }
        
        func text(_ string: String) -> some View {
            Text(string)
                .foregroundStyle(foregroundStyle)
        }
        
        @ViewBuilder
        func lowerText(withUnit: Bool = true) -> some View {
            if let lower {
                valueText(lower, withUnit)
            }
        }

        @ViewBuilder
        func upperText(withUnit: Bool = true) -> some View {
            if let upper {
                valueText(upper, withUnit)
            }
        }
        
        var maximum: some View {
            Group {
                text("Maximum")
                upperText()
            }
        }
        
        return HStack {
            switch type {
            case .lower:
                text("Minimum")
                lowerText()
            case .upper:
                maximum
            case .closed:
                if !allowZeroLowerBound, lower == 0 {
                    maximum
                } else {
                    HStack(spacing: 1) {
                        lowerText(withUnit: false)
                        text("-")
                        upperText()
                    }
                }
            case .none:
                emptyView
//                EmptyView()
//                DisabledLabel()
            }
        }
//        .frame(maxWidth: .infinity, alignment: .trailing)
    }
}
