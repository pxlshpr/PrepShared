import SwiftUI
import SwiftSugar

//public let DefaultGoalBoundFormatter: ((Double) -> (String)) = { "\($0.cleanAmount)" }

//let DefaultBoundNumberFont: Font = .system(.body, design: .monospaced, weight: .bold)
public let DefaultBoundNumberFont: Font = .system(.body)

/// -[ ] In Prep, make sure we're placing it in an HStack to account for removing the maxWidth frame modifier

public enum BoundNameStyle {
    case minMax
    case upToFrom
    case symbols
    
    var upperString: String {
        switch self {
        case .minMax:   "Maximum"
        case .upToFrom: "Up to"
        case .symbols:  "≤"
        }
    }
    
    var lowerString: String {
        switch self {
        case .minMax:   "Minimum"
        case .upToFrom: "From"
        case .symbols:  "≥"
        }
    }
}

public extension Bound {
    func text(
        foregroundStyle: some ShapeStyle = Color(.label),
        font: Font = DefaultBoundNumberFont,
        style: BoundNameStyle = .minMax,
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
                text(style.upperString)
                upperText()
            }
        }
        
        return HStack(spacing: 4) {
            switch type {
            case .lower:
                text(style.lowerString)
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
            }
        }
    }
}

func ageFormatter(_ age: Double) -> String {
    switch age {
    case 0.nextUp...1:  "\(age.cleanAmount)"
    default:            "\(Int(age))"
    }
}

#Preview {
    NavigationView {
        Form {
            ForEach([Bound(upper: 19), Bound(lower: 19), Bound(lower: 14, upper: 19)], id: \.self) {
                $0.text(
                    foregroundStyle: Color(.label),
                    font: .system(.body),
                    style: .symbols,
                    formatter: ageFormatter,
                    allowZeroLowerBound: true,
                    unitString: "years"
                )
            }
        }
    }
}
