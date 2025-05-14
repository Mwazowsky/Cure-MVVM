//
//  NameTxtCURE.swift
//  Cure
//
//  Created by MacBook Air MII  on 14/5/25.
//

import SwiftUI


@available(iOS 13.0.0, *)
struct NameTxtCURE: View {
    var text: String
    
    var body: some View {
        if #available(iOS 17.0, *) {
            Text(text)
                .font(DesignTokens.Typography.bodyFont)
                .foregroundStyle(Color(DesignTokens.Colors.primaryCURE))
        } else {
            Text(text)
                .font(DesignTokens.Typography.bodyFont)
                .foregroundColor(DesignTokens.Colors.primaryCURE)
        }
    }
}
