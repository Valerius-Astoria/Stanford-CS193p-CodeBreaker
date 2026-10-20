//
//  PegChoicesChooser.swift
//  CodeBreaker2
//
//  Created by ZAKA on 10/18/26.
//
import SwiftUI

struct PegChoicesChooser: View {

    // MARK: - Data Shared with Me
    @Binding var pegChoices: [Peg]

    // MARK: - Body
    var body: some View {
        List {
            ForEach(pegChoices.indices, id: \.self) { index in
                ColorPicker(selection: colorBinding(for: index), supportsOpacity: false) {
                    button("Peg Choice \(index + 1)", systemImage: "minus.circle", color: .red) {
                        pegChoices.remove(at: index)
                    }
                }
            }
            // Add a new peg choice.
            button("Add", systemImage: "plus.circle", color: .green) {
                pegChoices.append(Color.green.hexString)
            }
        }
    }

    /// Adapts the hex string at `index` to a `Color` binding for `ColorPicker`.
    ///
    /// The bounds checks matter: SwiftUI can re-evaluate a binding for a row
    /// that was just removed, and an unchecked subscript would crash.
    private func colorBinding(for index: Int) -> Binding<Color> {
        Binding(
            get: {
                guard pegChoices.indices.contains(index) else { return .clear }
                return Color(hex: pegChoices[index]) ?? .clear
            },
            set: { newColor in
                guard pegChoices.indices.contains(index) else { return }
                pegChoices[index] = newColor.hexString
            }
        )
    }

    // Customized button with image and title appears on the same row.
    func button(
        _ title: String, // No argument name for this property.
        systemImage: String,
        color: Color? = nil, // optional
        action: @escaping () -> Void
    ) -> some View {
        HStack {
            Button {
                action()
            } label: {
                Image(systemName: systemImage).foregroundStyle(color ?? .accentColor)
            }
            .buttonStyle(.borderless) // Keeps the tap on the icon, not the whole List row.
            Text(title)
        }
    }
}

#Preview {
    @Previewable @State var pegChoices: [Peg] = [Color.red, .green, .blue, .yellow].map(\.hexString)
    PegChoicesChooser(pegChoices: $pegChoices)
}
