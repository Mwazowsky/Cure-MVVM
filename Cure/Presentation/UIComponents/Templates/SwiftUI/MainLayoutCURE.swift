//
//  MainLayoutCURE.swift
//  Cure
//
//  Created by MacBook Air MII  on 8/5/25.
//

import SwiftUI

@available(iOS 13.0.0, *)
struct MainLayoutCURE<Content: View>: View {
    @ViewBuilder let content: () -> Content
    
    var body: some View {
        NavigationView {
            content()
                .modifier(NavBarModifier())
        }
        .background(DesignTokens.Colors.background)
        .edgesIgnoringSafeArea(.all)
    }
}
