import SwiftUI

public struct MenuPicker<T: Pickable>: View {

    let options: [T]
    let binding: Binding<T>
    
    public init(_ options: [T], _ binding: Binding<T>) {
        self.options = options
        self.binding = binding
    }

    public init(_ binding: Binding<T>) {
        self.options = T.allCases as! [T]
        self.binding = binding
    }

    public init(_ binding: Binding<T?>) {
        self.options = T.allCases as! [T]
        self.binding = Binding<T>(
            get: { binding.wrappedValue ?? T.noneOption ?? T.default },
            set: { binding.wrappedValue = $0 }
        )
    }
    
    public var body: some View {
        Menu {
            Picker(selection: binding, label: EmptyView()) {
                noneSection
                optionsSection
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
    var noneSection: some View {
        if let none = T.noneOption {
            Section {
                Text(none.menuTitle)
                    .tag(none)
            }
        }
    }
    
    var optionsSection: some View {
        Section {
            ForEach(optionsWithoutNone, id: \.self) { option in
                Group {
                    if option.menuImage.isEmpty {
                        Text(option.menuTitle)
                    } else {
                        Label(option.menuTitle, systemImage: option.menuImage)
                    }
                }
                .tag(option)
            }
        }
    }
    
    var label: some View {
        HStack(spacing: 4) {
            Text(binding.wrappedValue.pickedTitle)
            Image(systemName: "chevron.up.chevron.down")
                .imageScale(.small)
        }
        .foregroundStyle(foregroundColor)
    }
    
    var foregroundColor: Color {
        if let none = T.noneOption, binding.wrappedValue == none {
            Color(.tertiaryLabel)
        } else {
            Color(.secondaryLabel)
        }
    }
}
