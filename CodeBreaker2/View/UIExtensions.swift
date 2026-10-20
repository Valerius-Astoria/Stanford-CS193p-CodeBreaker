//
//  UIExtensions.swift
//  CodeBreaker2
//
//  Created by ZAKA on 10/15/26.
//

import SwiftUI

extension Color {
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
    
    func mask(isOver:Bool) -> some View {
        return self
            .transaction(value: isOver) { transaction in
                if isOver {
                    transaction.animation = nil
                }
            }
    }
}

extension AnyTransition {
    static func attempt() -> AnyTransition {
        return AnyTransition.asymmetric(
            insertion: .move(edge: .top),
            removal: .move(edge: .trailing))
    }
}

extension Animation {
    static let masterCode: Animation = .easeInOut
    static let selection: Animation = .easeInOut
}
