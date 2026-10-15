//
//  UIExtensions.swift
//  CodeBreaker2
//
//  Created by ZAKA on 10/15/26.
//

import SwiftUI

extension Color {
    static let missing = Color.clear
    
    static func gray(_ brightness: CGFloat) -> Color { // CGFloat represents float when working with UI
        return Color(hue: 138/360, saturation: 0, brightness: brightness)
    }
}

extension View {
    func flexibleSystemFont(minimum: CGFloat = 8, maximum: CGFloat = 80) -> some View {
        self
            .font(.system(size: maximum))
            .minimumScaleFactor(minimum/maximum)
    }
}
