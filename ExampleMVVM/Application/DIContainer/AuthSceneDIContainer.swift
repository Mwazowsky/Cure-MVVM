//
//  AuthSceneDIContainer.swift
//  ExampleMVVM
//
//  Created by MacBook Air MII  on 19/03/25.
//

import Foundation
import UIKit
import SwiftUI

final class AuthSceneDIContainer {
    struct Dependencies {
        let apiDataTransferService: DataTransferService
    }
    
    private let dependencies: Dependencies
//    private lazy var authPersistenceService: AuthPersistenceService = {
//        return DefaultAuthPersistenceService()
//    }()
    
    // Replace: Replace with a proper keychain storage to store user login response data
    lazy var moviesQueriesStorage: MoviesQueriesStorage  = CoreDataMoviesQueriesStorage(maxStorageLimit: 10)
    lazy var moviesResponseCache : MoviesResponseStorage = CoreDataMoviesResponseStorage()
    
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    // MARK: - Repositories
    private func makeAuthRepository() -> AuthRepository {
        return DefaultAuthRepository(
            dataTransferService: dependencies.apiDataTransferService,
            cache: moviesResponseCache
        )
    }
    
    private func makeUserRepository() -> UsersRepository {
        return DefaultUsersRepository(
            dataTransferService: dependencies.apiDataTransferService,
            cache: moviesResponseCache
        )
    }
    
    // MARK: - Use Cases
    func makeLoginUseCase() -> LoginUseCase {
        return DefaultLoginUseCase(authRepository: makeAuthRepository())
    }
    
    func makeRegisterUseCase() -> RegisterUseCase {
        return DefaultRegisterUseCase(authRepository: makeAuthRepository())
    }
    
    func makeResetPasswordUseCase() -> ResetPasswordUseCase {
        return DefaultResetPasswordUseCase(authRepository: makeAuthRepository())
    }
    
    func makeLogoutUseCase() -> LogoutUseCase {
        return DefaultLogoutUseCase(authRepository: makeAuthRepository())
    }
    
    func makeGetCurrentUserUseCase() -> GetCurrentUserUseCase {
        return DefaultGetCurrentUserUseCase(userRepository: makeUserRepository())
    }
    
    // MARK: - View Models
    func makeLoginViewModel(actions: LoginViewModelActions) -> LoginViewModel {
        return DefaultLoginViewModel(
            loginUseCase: makeLoginUseCase(),
            actions: actions
        )
    }
    
//    func makeRegisterViewModel(actions: RegisterViewModelActions) -> RegisterViewModel {
//        return DefaultRegisterViewModel(
//            registerUseCase: makeRegisterUseCase(),
//            actions: actions
//        )
//    }
//    
//    func makeResetPasswordViewModel(actions: ResetPasswordViewModelActions) -> ResetPasswordViewModel {
//        return DefaultResetPasswordViewModel(
//            resetPasswordUseCase: makeResetPasswordUseCase(),
//            actions: actions
//        )
//    }
    
    // MARK: - View Controllers
    func makeLoginViewController(actions: LoginViewModelActions) -> LoginViewController {
        return LoginViewController.create(
            with: makeLoginViewModel(actions: actions)
        )
    }
    
//    func makeRegisterViewController(actions: RegisterViewModelActions) -> RegisterViewController {
//        return RegisterViewController.create(
//            with: makeRegisterViewModel(actions: actions)
//        )
//    }
//    
//    func makeResetPasswordViewController(actions: ResetPasswordViewModelActions) -> ResetPasswordViewController {
//        return ResetPasswordViewController.create(
//            with: makeResetPasswordViewModel(actions: actions)
//        )
//    }
    
    // MARK: - Flow Coordinator
    func makeAuthFlowCoordinator(
        navigationController: UINavigationController,
        delegate: AuthFlowCoordinatorDelegate? = nil
    ) -> AuthFlowCoordinator {
        return AuthFlowCoordinator(
            navigationController: navigationController,
            dependencies: self,
            delegate: delegate
        )
    }
}

extension AuthSceneDIContainer: AuthFlowCoordinatorDependencies {}
