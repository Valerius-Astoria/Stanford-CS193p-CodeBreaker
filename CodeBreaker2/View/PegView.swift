//
//  PegView.swift
//  CodeBreaker2
//
//  Created by ZAKA on 10/14/26.
//

import SwiftUI

struct PegView: View {
    
    // MARK: - Data In
    var peg: Peg
    
    // MARK: - Private Data
    private let pegShape = Circle()
    
    // MARK: - Body
    var body: some View {
        pegShape
            .contentShape(pegShape) // Avoids the peg being unselectable. 
            .foregroundStyle(peg)
            .aspectRatio(1, contentMode: .fit)
    }
}

#Preview {
    PegView(peg: Color.red)
}
