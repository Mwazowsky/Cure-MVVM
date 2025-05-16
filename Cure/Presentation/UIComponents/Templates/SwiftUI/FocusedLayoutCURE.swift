//
//  FocusedLayoutCURE.swift
//  Cure
//
//  Created by MacBook Air MII  on 8/5/25.
//

import SwiftUI

@available(iOS 13.0.0, *)
struct FocusedLayoutCURE<Content: View>: View {
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack {
            Spacer()
            content()
                .padding(DesignTokens.Spacing.medium)
            Spacer()
        }
        .background(DesignTokens.Colors.background)
        .edgesIgnoringSafeArea(.all)
    }
}
