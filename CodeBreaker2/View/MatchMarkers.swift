//
//  MatchMarker.swift
//  CodeBreaker2
//
//  Created by ZAKA on 10/14/26.
//

import SwiftUI

struct MatchMarkers: View {
    
    // MARK: - Data In
    let matches: [Code.Match]
    let numOfPegs: Int
    
    // MARK: - Init
    init(matches: [Code.Match]) {
        self.matches = matches
        self.numOfPegs = matches.count
    }
    
    // MARK: - Body
    var body: some View {
        // Renders all match markers (the number of match markers ranges from 3 to 6)
        HStack {
            VStack{
                matchMarker(at: 0)
                matchMarker(at: 1)
            }
            VStack{
                matchMarker(at: 2)
                if (numOfPegs >= 4) {
                    matchMarker(at: 3)
                }
            }
            if (numOfPegs >= 5) {
                VStack{
                    matchMarker(at: 4)
                    if (numOfPegs >= 6) {
                        matchMarker(at: 5)
                    }
                }
            }
        }
    }
    
    /// Renders a single match marker at the specified position.
    ///
    /// - Parameter position: The position of the match marker to render.
    func matchMarker(at position: Int) -> some View {
        let exactCount = matches.count { $0 == .exact}
        let inexactCount = matches.count { $0 == .inexact}
        
        return Circle()
            .fill(exactCount > position ? Color.primary : Color.clear)
            .stroke((exactCount + inexactCount) > position ? Color.primary : Color.clear, lineWidth: 2)
    }
}

#Preview {
    MatchMarkers(matches: [.exact, .inexact, .nomatch, .nomatch])
}
