//
//  PrimaryBtnCURE.swift
//  Cure
//
//  Created by MacBook Air MII  on 8/5/25.
//

/// Atoms are the basic building blocks of a UI, such as buttons, texts, and icons.

import SwiftUI

@available(iOS 13.0.0, *)
struct PrimaryBtnCURE: View {
    var title: String
    
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(DesignTokens.Typography.bodyFont)
                .foregroundColor(.white)
                .frame(minWidth: 120, minHeight: 40)
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(DesignTokens.Colors.primaryCURE)
                .cornerRadius(25)
        }
    }
}
