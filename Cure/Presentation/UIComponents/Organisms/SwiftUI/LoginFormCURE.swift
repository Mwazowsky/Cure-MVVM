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
            
            DefaultTFCURE(
                isSecureTF: false,
                placeholder: "Email",
                text: binding(viewModelWrapper.viewModel?.email ?? Observable("")) { viewModelWrapper.viewModel?.updateEmail($0) },
                onTextChange: { viewModelWrapper.viewModel?.updateEmail($0) }
            )
            
            DefaultTFCURE(
                isSecureTF: true,
                placeholder: "Password",
                text: binding(viewModelWrapper.viewModel?.password ?? Observable("")) { viewModelWrapper.viewModel?.updatePassword($0) },
                onTextChange: { viewModelWrapper.viewModel?.updatePassword($0) }
            )
            
            PrimaryBtnCURE(title: "Login") {
                viewModelWrapper.viewModel?.didTapLoginButton()
            }
            
            TextBtnCURE(title: "Register") {
                viewModelWrapper.viewModel?.didTapRegisterButton()
            }
            
            TextBtnCURE(title: "Forgot Password?") {
                viewModelWrapper.viewModel?.didTapRegisterButton()
            }
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
    
    func binding<T>(_ observable: Observable<T>, onChange: @escaping (T) -> Void) -> Binding<T> {
        Binding<T>(
            get: { observable.value },
            set: { newValue in
                onChange(newValue)
            }
        )
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
