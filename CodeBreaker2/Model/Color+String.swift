//
//  Color+String.swift
//  CodeBreaker2
//
//  Created by ZAKA on 10/19/26.
//

import SwiftUI

extension Color {

    /// Creates a color from a hex string such as `"#FF0000"` or `"FF0000CC"`.
    ///
    /// The leading `#` is optional. Accepts 6 digits (RGB) or 8 digits (RGBA).
    /// Returns `nil` if the string isn't valid hex.
    init?(hex: String) {
        var string = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        if string.hasPrefix("#") { string.removeFirst() }

        guard string.count == 6 || string.count == 8,
              let value = UInt64(string, radix: 16) else { return nil }

        let red, green, blue, alpha: Double
        if string.count == 6 {
            red   = Double((value >> 16) & 0xFF) / 255
            green = Double((value >> 8)  & 0xFF) / 255
            blue  = Double(value         & 0xFF) / 255
            alpha = 1
        } else {
            red   = Double((value >> 24) & 0xFF) / 255
            green = Double((value >> 16) & 0xFF) / 255
            blue  = Double((value >> 8)  & 0xFF) / 255
            alpha = Double(value         & 0xFF) / 255
        }
        self.init(.sRGB, red: red, green: green, blue: blue, opacity: alpha)
    }

    /// The color as a hex string: `"#RRGGBB"`, or `"#RRGGBBAA"` if not fully opaque.
    var hexString: String {
        let resolved = resolve(in: EnvironmentValues())

        func byte(_ component: Float) -> Int {
            Int((min(max(component, 0), 1) * 255).rounded())
        }

        let hex = String(format: "#%02X%02X%02X",
                         byte(resolved.red), byte(resolved.green), byte(resolved.blue))
        let alpha = byte(resolved.opacity)
        return alpha == 255 ? hex : hex + String(format: "%02X", alpha)
    }
}
