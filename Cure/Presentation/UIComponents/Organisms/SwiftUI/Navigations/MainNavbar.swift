//
//  MainNavbar.swift
//  Cure
//
//  Created by MacBook Air MII  on 16/5/25.
//

import SwiftUI

@available(iOS 13.0.0, *)
struct NavBarModifier: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 14.0, *) {
            return AnyView(
                content
                    .navigationTitle("Chats")
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
                    .navigationBarTitle("Chats")
            )
        }
    }
}
