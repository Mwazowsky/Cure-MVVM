//
//  PrimaryTxtCURE.swift
//  Cure
//
//  Created by MacBook Air MII  on 8/5/25.
//

import SwiftUI


@available(iOS 13.0.0, *)
struct SecondaryTxtCURE: View {
    var text: String
    
    var body: some View {
        if #available(iOS 17.0, *) {
            Text(text)
                .font(DesignTokens.Typography.bodyFont)
                .foregroundStyle(Color(DesignTokens.Colors.primaryCURE))
        } else {
            Text(text)
                .font(DesignTokens.Typography.titleFont)
                .foregroundColor(DesignTokens.Colors.primaryCURE)
        }
    }
}
