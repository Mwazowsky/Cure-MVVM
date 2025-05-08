//
//  IconCURE.swift
//  Cure
//
//  Created by MacBook Air MII  on 8/5/25.
//

import SwiftUICore

@available(iOS 13.0.0, *)
struct IconCURE: View {
    var systemName: String
    var body: some View {
        Image(systemName: systemName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 24, height: 24)
            .foregroundColor(DesignTokens.Colors.secondary)
    }
}
