//
//  LoginViewModel.swift
//  ExampleMVVM
//
//  Created by MacBook Air MII  on 19/03/25.
//

import Foundation

struct AccountViewModelActions {
    let showForgotPassword: () -> Void
    let logoutDidSucceed: () -> Bool
}

protocol AccountViewModelInput {
    func viewDidLoad()
    func didTapLogoutButton()
    func didTapForgotPasswordButton()
}

protocol AccountViewModelOutput {
    var isLoading: Observable<Bool> { get }
    var error: Observable<String?> { get }
}

typealias AccountViewModel = AccountViewModelInput & AccountViewModelOutput

final class DefaultAccountViewModel: AccountViewModel {
    // MARK: - Output
    let isLoading: Observable<Bool> = Observable(false)
    let error: Observable<String?> = Observable(nil)
    
    // MARK: - Private
    private let logoutUseCase: LogoutUseCase
    private let actions: AccountViewModelActions
    
    // MARK: - Init
    init(
        logoutUseCase: LogoutUseCase,
        actions: AccountViewModelActions
    ) {
        self.logoutUseCase = logoutUseCase
        self.actions = actions
    }
    
    // MARK: - Input
    func viewDidLoad() {
        
    }
    
    func didTapLogoutButton() {
        print("This Logout Buttonjhsdbhb")
        isLoading.value = true
        error.value = nil
        
        logoutUseCase.execute() { [weak self] result in
            guard let self = self else { return }
            self.isLoading.value = false
            switch result {
            case .success(let user):
                let isloggedOut = self.actions.logoutDidSucceed()
            case .failure(let error):
                self.error.value = self.mapErrorToMessage(error as! AuthenticationError)
            }
        }
        
        let isloggedOut = self.actions.logoutDidSucceed()
    }
    
    
    func didTapForgotPasswordButton() {
        actions.showForgotPassword()
    }
    
    
    private func mapErrorToMessage(_ error: AuthenticationError) -> String {
        switch error {
        case .invalidCredentials:
            return "Invalid username or Password. Please try again."
        case .networkFailure:
            return "Network Error. Please check your internet connection"
        case .serverError(let message):
            return "Server error: \(message)"
        default:
            return "An unknown error occurred. Please try again."
        }
    }
}
