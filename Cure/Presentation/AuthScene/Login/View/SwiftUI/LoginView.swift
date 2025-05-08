//
//  LoginView.swift
//  Cure
//
//  Created by MacBook Air MII  on 8/5/25.
//

import SwiftUI

@available(iOS 13.0, *)
extension DefaultLoginViewModel: Identifiable { }

@available(iOS 13.0, *)
struct LoginView: View {
    @ObservedObject var viewModelWrapper: LoginViewModelWrapper
    
    var body: some View {
        NavigationView {
            LoginPage()
                .navigationBarHidden(true)
        }
    }
}

@available(iOS 13.0, *)
final class LoginViewModelWrapper: ObservableObject {
    var viewModel: LoginViewModel?
    
    init(viewModel: LoginViewModel?) {
        self.viewModel = viewModel
    }
}

#if DEBUG
@available(iOS 13.0, *)
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(viewModelWrapper: previewViewModelWrapper)
    }

    static var previewViewModelWrapper: LoginViewModelWrapper = {
        var viewModel = LoginViewModelWrapper(viewModel: nil)
        return viewModel
    }()
}
#endif
