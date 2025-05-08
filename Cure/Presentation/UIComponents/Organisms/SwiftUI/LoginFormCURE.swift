//
//  LoginFormCURE.swift
//  Cure
//
//  Created by MacBook Air MII  on 8/5/25.
//

import SwiftUI

@available(iOS 13.0.0, *)
struct LoginFormCURE: View {
    @State private var username: String = ""
    @State private var password: String = ""
    
    var body: some View {
        VStack(spacing: DesignTokens.Spacing.small) {
            LabeledFormCURE(label: "Username")
            
            LabeledFormCURE(label: "Password")
        }
    }
}

#if DEBUG
@available(iOS 13.0, *)
struct LoginForm_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(viewModelWrapper: previewViewModelWrapper)
    }

    static var previewViewModelWrapper: LoginViewModelWrapper = {
        var viewModel = LoginViewModelWrapper(viewModel: nil)
        return viewModel
    }()
}
#endif
