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
    var size: CGFloat = 24
    
    var body: some View {
        Image(systemName: systemName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: size, height: size)
            .foregroundColor(DesignTokens.Colors.secondaryCURE)
    }
}
