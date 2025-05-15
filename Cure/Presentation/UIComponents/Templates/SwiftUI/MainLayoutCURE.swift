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
            //
            content()
                .modifier(NavBarModifier())
        }
        .background(DesignTokens.Colors.background)
        .edgesIgnoringSafeArea(.all)
    }
}

@available(iOS 13.0.0, *)
struct NavBarModifier: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 14.0, *) {
            return AnyView(
                content
                    .navigationTitle("Chats")
                    .navigationBarTitleDisplayMode(.automatic)
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button(action: {
                            }) {
                                Image(systemName: "arrow.up.arrow.down.circle")
                            }
                        }
                    }
            )
        } else {
            return AnyView(
                content
                    .navigationBarTitle("Chats", displayMode: .automatic)
            )
        }
    }
}
