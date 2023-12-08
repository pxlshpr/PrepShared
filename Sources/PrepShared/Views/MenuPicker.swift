import SwiftUI

public struct MenuPicker<T: Pickable>: View {

    let options: [T]
    let binding: Binding<T>
    let isPlural: Bool
    
    //MARK: - Initializers
    
    public init(
        _ options: [T],
        _ binding: Binding<T>,
        isPlural: Bool = false
    ) {
        self.options = options
        self.binding = binding
        self.isPlural = isPlural
    }

    public init(_ binding: Binding<T>, isPlural: Bool = false) {
        self.options = T.allCases as! [T]
        self.binding = binding
        self.isPlural = isPlural
    }

    public init(_ binding: Binding<T?>, isPlural: Bool = false) {
        self.options = T.allCases as! [T]
        self.binding = Binding<T>(
            get: { binding.wrappedValue ?? T.noneOption ?? T.default },
            set: { binding.wrappedValue = $0 }
        )
        self.isPlural = isPlural
    }

    public init(_ options: [T], _ binding: Binding<T?>, isPlural: Bool = false) {
        self.options = options
        self.binding = Binding<T>(
            get: { binding.wrappedValue ?? T.noneOption ?? T.default },
            set: { binding.wrappedValue = $0 }
        )
        self.isPlural = isPlural
    }

    //MARK: - Body
    
    public var body: some View {
        Menu {
            Picker(selection: binding, label: EmptyView()) {
                noneContent
                optionsContent
            }
        } label: {
            label
        }
        .padding(.leading, 5)
        .padding(.vertical, 3)
        .contentShape(Rectangle())
        .hoverEffect(.highlight)
        .animation(.none, value: binding.wrappedValue)
    }
    
    var optionsWithoutNone: [T] {
        if let none = T.noneOption {
            options.filter { $0 != none }
        } else {
            options
        }
    }
    
    @ViewBuilder
    var noneContent: some View {
        if let none = T.noneOption, options.contains(none) {
            Text(isPlural ? none.pluralMenuTitle : none.menuTitle)
                .font(.body)
                .textCase(.none)
                .tag(none)
            Divider()
        }
    }
    
    var optionsContent: some View {
        ForEach(optionsWithoutNone, id: \.self) { option in
            Group {
                if option.menuImage.isEmpty {
                    Text(isPlural ? option.pluralMenuTitle : option.menuTitle)
                } else {
                    Label(option.menuTitle, systemImage: option.menuImage)
                }
            }
            .font(.body)
            .textCase(.none)
            .tag(option)
        }
    }
    
    var label: some View {
        HStack(spacing: 4) {
            Text(isPlural ? binding.wrappedValue.pluralPickedTitle : binding.wrappedValue.pickedTitle)
                .textCase(.none)
            Image(systemName: "chevron.up.chevron.down")
                .imageScale(.small)
        }
        .font(.body)
//        .foregroundStyle(foregroundColor)
        .foregroundStyle(Color(.label))
    }
    
    var foregroundColor: Color {
        if let none = T.noneOption, binding.wrappedValue == none {
            Color(.tertiaryLabel)
        } else {
            Color(.secondaryLabel)
        }
    }
}
