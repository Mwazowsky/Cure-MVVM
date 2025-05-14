//
//  LoginFormCURE.swift
//  Cure
//
//  Created by MacBook Air MII  on 8/5/25.
//

import SwiftUI

@available(iOS 13.0.0, *)
struct NavBarCURE: View {
    var body: some View {
        ZStack(alignment: .bottom) {
            DesignTokens.Colors.primaryCURE
                .edgesIgnoringSafeArea(.top)
        
            HStack {
                IconCURE(systemName: "arrow.left")
                Spacer()
                PrimaryTxtCURE(text: "Title")
                Spacer()
                IconCURE(systemName: "gear")
            }
            .padding()
        }
        .frame(maxHeight: 100)
    }
}
