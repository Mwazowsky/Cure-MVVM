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
    
    private let windowManager: WindowManageable
    
    private let dependencies: Dependencies
    
    lazy var moviesQueriesStorage: MoviesQueriesStorage  = CoreDataMoviesQueriesStorage(maxStorageLimit: 10)
    lazy var moviesResponseCache : MoviesResponseStorage = CoreDataMoviesResponseStorage()
    
    
    init(dependencies: Dependencies, windowManager: WindowManageable) {
        self.dependencies = dependencies
        self.windowManager = windowManager
    }
    
    // MARK: - Repositories
    private func makeKeychainRepository() -> IKeychainRepository {
        return DefaultKeychainRepository()
    }
    
    private func makeAuthRepository() -> IAuthRepository {
        return DefaultAuthRepository(
            dataTransferService: dependencies.newApiDataTransferervice
        )
    }
    
    // MARK: - Use Cases
    /// User Data Get
    func makeGetCurrentUserTokenUseCase() -> GetUserTokenUseCase {
        return DefaultGetCurrentUserTokenUseCase(keychainRepository: makeKeychainRepository())
    }
    
    func makeLogoutUserUseCase() -> LogoutUseCase {
        return DefaultLogoutUseCase(authRepository: makeAuthRepository(), keychainRepository: makeKeychainRepository())
    }
    
    // MARK: - View Models
    func makeHomeViewModel(actions: HomeViewModelActions) -> HomeViewModel {
        return DefaultHomeViewModel(
            getUserTokenDataUseCase: makeGetCurrentUserTokenUseCase(),
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
            appDIContainer: AppDIContainer(windowManager: windowManager),
            dependencies: self,
            delegate: delegate
        )
    }
}

extension HomeSceneDIContainer: HomeFlowCoordinatorDependencies {}
