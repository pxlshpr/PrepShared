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
            get: { binding.wrappedValue ?? T.default },
            set: { binding.wrappedValue = $0 }
        )
    }

    public var body: some View {
        Menu {
            Picker(selection: binding, label: EmptyView()) {
                ForEach(options, id: \.self) { option in
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
        } label: {
            label
        }
        .padding(.leading, 5)
        .padding(.vertical, 3)
        .contentShape(Rectangle())
        .hoverEffect(.highlight)
        .animation(.none, value: binding.wrappedValue)
    }
    
    var label: some View {
        HStack(spacing: 4) {
            Text(binding.wrappedValue.pickedTitle)
            Image(systemName: "chevron.up.chevron.down")
                .imageScale(.small)
        }
        .foregroundStyle(Color(.secondaryLabel))
    }
}
