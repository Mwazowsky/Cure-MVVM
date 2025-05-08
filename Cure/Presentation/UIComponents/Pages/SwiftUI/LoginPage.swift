//
//  LoginPage.swift
//  Cure
//
//  Created by MacBook Air MII  on 8/5/25.
//

import SwiftUI

@available(iOS 13.0.0, *)
struct LoginPage: View {
    var body: some View {
        FocusedLayoutCURE {
            LoginFormCURE()
        }
    }
}

#if DEBUG
@available(iOS 13.0, *)
struct LoginPage_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(viewModelWrapper: previewViewModelWrapper)
    }

    static var previewViewModelWrapper: LoginViewModelWrapper = {
        var viewModel = LoginViewModelWrapper(viewModel: nil)
        return viewModel
    }()
}
#endif
