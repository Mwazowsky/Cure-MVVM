//
//  PrimaryTxtCURE.swift
//  Cure
//
//  Created by MacBook Air MII  on 8/5/25.
//

import SwiftUICore


@available(iOS 13.0.0, *)
struct PrimaryTxtCURE: View {
    var text: String
    
    var body: some View {
        if #available(iOS 17.0, *) {
            Text(text)
                .font(DesignTokens.Typography.titleFont)
                .foregroundStyle(Color(DesignTokens.Colors.primary))
        } else {
            Text(text)
                .font(DesignTokens.Typography.titleFont)
                .foregroundColor(DesignTokens.Colors.primary)
        }
    }
}
