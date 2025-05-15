//
//  OAuthBtnGroupCURE.swift
//  Cure
//
//  Created by MacBook Air MII  on 14/5/25.
//

import SwiftUI

@available(iOS 13.0.0, *)
struct OAuthBtnGroupCURE: View {
    var body: some View {
        HStack(spacing: 10) {
            OAuthLoginButton(title: "Google", imageName: "magnifyingglass.circle.fill") {

            }
            OAuthLoginButton(title: "Apple", imageName: "magnifyingglass.circle.fill") {

            }
        }
    }
}
