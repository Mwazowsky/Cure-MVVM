//
//  IconBtnCURE.swift
//  Cure
//
//  Created by MacBook Air MII  on 14/5/25.
//

import SwiftUI

@available(iOS 13.0.0, *)
struct OAuthLoginButton: View {
    var title: String
    var imageName: String
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.black)

                Text(title)
                    .font(DesignTokens.Typography.bodyFont)
                    .foregroundColor(.black)
            }
            .frame(maxHeight: 44)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 3)
        .background(DesignTokens.Colors.secondaryCURE)
        .cornerRadius(25)
        .overlay(
            RoundedRectangle(cornerRadius: 25)
                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
        )
    }
}
