//
//  HomeDIContainer.swift
//  Cure
//
//  Created by MacBook Air MII  on 25/3/25.
//

import UIKit
import SwiftUI

final class HomeSceneDIContainer {
    struct Dependencies {
        let newApiDataTransferervice: DataTransferService
    }
    
    private let dependencies: Dependencies
    
    lazy var moviesQueriesStorage: MoviesQueriesStorage  = CoreDataMoviesQueriesStorage(maxStorageLimit: 10)
    lazy var moviesResponseCache : MoviesResponseStorage = CoreDataMoviesResponseStorage()
    
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    // MARK: - Repositories
    private func makeAuthRepository() -> AuthRepository {
        return DefaultAuthRepository(
            dataTransferService: dependencies.newApiDataTransferervice,
            cache: moviesResponseCache
        )
    }
    
    private func makeUserRepository() -> UsersRepository {
        return DefaultUsersRepository(
            dataTransferService: dependencies.newApiDataTransferervice,
            cache: moviesResponseCache
        )
    }
    
    // MARK: - Use Cases
    /// Auth
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
    
    /// User Data Get
    func makeGetCurrentUserUseCase() -> GetUserUseCase {
        return DefaultGetCurrentUserUseCase(userRepository: makeUserRepository())
    }
    
    // MARK: - View Models
    func makeHomeViewModel(actions: HomeViewModelActions) -> HomeViewModel {
        return DefaultHomeViewModel(
            getUserDataUseCase: makeGetCurrentUserUseCase(),
            actions: actions
        )
    }
    
    // MARK: - View Controllers
    func makeHomeViewController(actions: HomeViewModelActions) -> HomeViewController {
        return HomeViewController.create(
            with: makeHomeViewModel(actions: actions)
        )
    }
    
    // MARK: - Flow Coordinator
    func makeHomeFlowCoordinator(
        navigationController: UINavigationController,
        delegate: HomeFlowCoordinatorDelegate? = nil
    ) -> HomeFlowCoordinator {
        return HomeFlowCoordinator(
            navigationController: navigationController,
            dependencies: self,
            delegate: delegate
        )
    }
}

extension HomeSceneDIContainer: HomeFlowCoordinatorDependencies {}
