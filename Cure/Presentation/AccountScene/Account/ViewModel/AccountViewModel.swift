//
//  LoginViewModel.swift
//  ExampleMVVM
//
//  Created by MacBook Air MII  on 19/03/25.
//

import Foundation

struct AccountViewModelActions {
    let showForgotPassword: () -> Void
    let logoutDidSucceed: () -> Void
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
    private let fetchUserDetailsUseCase: FetchUserDetailsUseCase
    private let actions: AccountViewModelActions
    
    // MARK: - Init
    init(
        fetchUserDetailsUseCase: FetchUserDetailsUseCase,
        logoutUseCase: LogoutUseCase,
        actions: AccountViewModelActions
    ) {
        self.fetchUserDetailsUseCase = fetchUserDetailsUseCase
        self.logoutUseCase = logoutUseCase
        self.actions = actions
    }
    
    // MARK: - Input
    func viewDidLoad() {
        fetchUserDetailsUseCase.execute(
            cached: { cachedUser in
                print("Using cached user: \(cachedUser)")
            },
            completion: { [weak self] result in
//                guard let self = self else { return }
                switch result {
                case .success(let userDetails):
                    print("User Details: ", userDetails)
//                    self.actions.loginDidSucceed(userDetails)
                case .failure(let error):
                    print("Error fetching user details: \(error)")
                }
            }
        )
    }
    
    func didTapLogoutButton() {
        isLoading.value = true
        error.value = nil
        
        logoutUseCase.execute() { [weak self] result in
            guard let self = self else { return }
            self.isLoading.value = false
            switch result {
            case .success(_):
                self.actions.logoutDidSucceed()
            case .failure(let error):
                self.error.value = self.mapErrorToMessage(error as! AuthenticationError)
            }
        }
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
