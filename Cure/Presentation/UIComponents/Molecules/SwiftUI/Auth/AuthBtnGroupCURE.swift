
//
//  OAuthBtnGroupCURE.swift
//  Cure
//
//  Created by MacBook Air MII  on 14/5/25.
//

import SwiftUI

@available(iOS 13.0.0, *)
struct AuthBtnGroupCURE: View {
    var body: some View {
        VStack(spacing: 10) {
            TextBtnCURE(title: "Register") {
//                viewModelWrapper.viewModel?.didTapRegisterButton()
            }
            
            TextBtnCURE(title: "Forgot Password?") {
//                viewModelWrapper.viewModel?.didTapRegisterButton()
            }
        }
    }
}
