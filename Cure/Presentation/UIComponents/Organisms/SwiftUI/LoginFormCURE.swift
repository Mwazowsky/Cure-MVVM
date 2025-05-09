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
            // Change this into an atoms or molecule whatever suits the architectural pattern
            TextField("Email", text: binding(viewModelWrapper.viewModel?.email ?? Observable("")) {
                viewModelWrapper.viewModel?.updateEmail($0)
            })
            .textContentType(.emailAddress)
            .keyboardType(.emailAddress)
            .autocapitalization(.none)
            .disableAutocorrection(true)
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(8)
            
            // Change this into an atoms or molecule whatever suits the architectural pattern
            SecureField("Password", text: binding(viewModelWrapper.viewModel?.password ?? Observable("")) {
                viewModelWrapper.viewModel?.updatePassword($0)
            })
            .textContentType(.password)
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(8)
            
            PrimaryBtnCURE(title: "Login") {
                viewModelWrapper.viewModel?.didTapLoginButton()
            }
            
            Button("Register") {
                viewModelWrapper.viewModel?.didTapRegisterButton()
            }
            
            Button("Forgot Password?") {
                viewModelWrapper.viewModel?.didTapForgotPasswordButton()
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
