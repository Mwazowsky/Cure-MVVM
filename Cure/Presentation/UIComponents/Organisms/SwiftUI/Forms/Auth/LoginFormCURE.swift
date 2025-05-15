//
//  LoginFormCURE.swift
//  Cure
//
//  Created by MacBook Air MII  on 8/5/25.
//

import SwiftUI

@available(iOS 13.0.0, *)
struct LoginFormCURE: View {
    @ObservedObject var viewModelWrapper: LoginViewModelWrapper
    
    var body: some View {
        VStack(spacing: 16) {
            
            PrimaryTxtCURE(text: "Welcome to CURE!")
                .padding(.bottom, 25)
            
            AuthFieldsGroupCURE(viewModelWrapper: viewModelWrapper)
            
            PrimaryBtnCURE(title: "Login") {
                viewModelWrapper.viewModel?.didTapLoginButton()
            }
            
            AuthBtnGroupCURE()
            
            OAuthBtnGroupCURE()
                .padding(.top, 8)
        }
        .padding()
        .onTapGesture {
            hideKeyboard()
        }
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                        to: nil, from: nil, for: nil)
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
