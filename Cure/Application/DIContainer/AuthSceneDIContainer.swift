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
        let newApiDataTransferervice: DataTransferService
    }
    
    private let dependencies: Dependencies
    
    lazy var userResponseCache : UserDetailsResponseStorage = CoreDataUserDetailsResponseStorage()
    
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    // MARK: - Repositories
    private func makeAuthRepository() -> IAuthRepository {
        return DefaultAuthRepository(
            dataTransferService: dependencies.newApiDataTransferervice
        )
    }
    
    private func makeDeviceInfoRepository() -> IDeviceInfoRepository {
        return DefaultDeviceInfoRepository()
    }
    
    private func makeKeychainRepository() -> IKeychainRepository {
        return DefaultKeychainRepository()
    }
    
    private func makeUserRepository() -> IUserRepository {
        return DefaultUserRepository(
            dataTransferService: dependencies.newApiDataTransferervice,
            cache: userResponseCache
        )
    }
    
    // MARK: - Use Cases
    /// Auth
    func makeLoginUseCase() -> LoginUseCase {
        return DefaultLoginUseCase(authRepository: makeAuthRepository(), deviceInfoRepository: makeDeviceInfoRepository())
    }
    
    func makeRegisterUseCase() -> RegisterUseCase {
        return DefaultRegisterUseCase(authRepository: makeAuthRepository())
    }
    
    func makeResetPasswordUseCase() -> ResetPasswordUseCase {
        return DefaultResetPasswordUseCase(authRepository: makeAuthRepository())
    }
    
    /// User Data Save
    func makeSaveCurrentLoginTokenUseCase() -> SaveLoginTokenUseCase {
        return DefaultSaveLoginTokenUseCase(keychainRepository: makeKeychainRepository())
    }

    func makeFetchUserDetailsUseCase() -> FetchUserDetailsUseCase {
        return DefaultFetchUserDetailsUseCase(userRepository: makeUserRepository())
    }
    
    // MARK: - View Models
    func makeLoginViewModel(actions: LoginViewModelActions) -> LoginViewModel {
        return DefaultLoginViewModel(
            loginUseCase: makeLoginUseCase(),
            fetchUserDetailsUseCase: makeFetchUserDetailsUseCase(),
            saveLoginTokenDataUseCase: makeSaveCurrentLoginTokenUseCase(),
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
    func makeLoginViewController(actions: LoginViewModelActions) -> UIViewController {
//        if #available(iOS 13.0, *) { // SwiftUI
//            let view = LoginView(
//                viewModelWrapper: makeLoginViewModelWrapper(actions: actions)
//            )
//            return UIHostingController(rootView: view)
//        } else { // UIKit
            return LoginViewController.create(
                with: makeLoginViewModel(actions: actions)
            )
//        }
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
    
    @available(iOS 13.0, *)
    func makeLoginViewModelWrapper(
        actions: LoginViewModelActions
    ) -> LoginViewModelWrapper {
        LoginViewModelWrapper(
            viewModel: makeLoginViewModel(actions: actions)
        )
    }
    
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
