//
//  LoginViewModel.swift
//  ExampleMVVM
//
//  Created by MacBook Air MII  on 19/03/25.
//

import Foundation

struct LoginViewModelActions {
    let showRegister: () -> Void
    let showForgotPassword: () -> Void
    let loginDidSucceed: (LoginResponse) -> Void
}

protocol LoginViewModelInput {
    func viewDidLoad()
    func didTapLoginButton()
    func didTapRegisterButton()
    func didTapForgotPasswordButton()
    func updateEmail(_ email: String)
    func updatePassword(_ password: String)
}

protocol LoginViewModelOutput {
    var email: Observable<String> { get }
    var password: Observable<String> { get }
    var isLoading: Observable<Bool> { get }
    var error: Observable<String?> { get }
    var isLoginButtonEnabled: Observable<Bool> { get }
}

typealias LoginViewModel = LoginViewModelInput & LoginViewModelOutput

final class DefaultLoginViewModel: LoginViewModel {
    // MARK: - Output
    let email: Observable<String> = Observable("")
    let password: Observable<String> = Observable("")
    let isLoading: Observable<Bool> = Observable(false)
    let error: Observable<String?> = Observable(nil)
    let isLoginButtonEnabled: Observable<Bool> = Observable(false)
    
    // MARK: - Private
    private let loginUseCase: LoginUseCase
    private let actions: LoginViewModelActions
    
    // MARK: - Init
    init(
        loginUseCase: LoginUseCase,
        actions: LoginViewModelActions
    ) {
        self.loginUseCase = loginUseCase
        self.actions = actions
    }
    
    // MARK: - Input
    func viewDidLoad() {
        validateInputs()
    }
    
    func didTapLoginButton() {
        print("Login Button Tapped")
        
        isLoading.value = true
        error.value = nil
        
        let request = LoginUseCaseRequestValue(
            email: email.value,
            password: password.value
        )
        
        loginUseCase.execute(requestValue: request) { [weak self] result in
            guard let self = self else { return }
            self.isLoading.value = false
            
            var userData: LoginResponse = LoginResponse(
                id: "65123456",
                email: "saifulloh.fadli@gmail.com",
                role: .staff,
                token: "15243vahsvqw8"
            )
            
            switch result {
            case .success(let user):
                userData = user
                self.actions.loginDidSucceed(user)
            case .failure(let error):
                self.error.value = self.mapErrorToMessage(error)
            }
            
            self.actions.loginDidSucceed(userData)
        }
    }
    
    
    func didTapRegisterButton() {
        actions.showRegister()
    }
    
    
    func didTapForgotPasswordButton() {
        actions.showForgotPassword()
    }
    
    
    func updateEmail(_ email: String) {
        self.email.value = email
        validateInputs()
    }
    
    
    func updatePassword(_ password: String) {
        self.password.value = password
        validateInputs()
    }
    
    
    // MARK: - Private
    private func validateInputs() {
        let isEmailValid = !email.value.isEmpty && email.value.contains("@")
        let isPasswordValid = !password.value.isEmpty && password.value.count >= 6
        
        isLoginButtonEnabled.value = isEmailValid && isPasswordValid
    }
    
    
    private func mapErrorToMessage(_ error: AuthenticationError) -> String {
        switch error {
        case .invalidCredentials:
            return "Invalid Email or Password. Please try again."
        case .networkFailure:
            return "Network Error. Please check your internet connection"
        case .serverError(let message):
            return "Server error: \(message)"
        default:
            return "An unknown error occurred. Please try again."
        }
    }
}
