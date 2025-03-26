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
    
    // Replace: Replace with a proper keychain storage to store user login response data
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
    
//    func makeHomeQueriesRepository() -> HomeQueriesRepository {
//        DefaultMoviesQueriesRepository(
//            moviesQueriesPersistentStorage: moviesQueriesStorage
//        )
//    }
    
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
    
//    func makeFetchRecentHomeQueriesUseCase(
//        requestValue: FetchRecentHomeQueriesUseCase.RequestValue,
//        completion: @escaping (FetchRecentHomeQueriesUseCase.ResultValue) -> Void
//    ) -> UseCase {
//        FetchRecentHomeQueriesUseCase(
//            requestValue: requestValue,
//            completion: completion,
//            homeQueriesRepository: makeMoviesQueriesRepository()
//        )
//    }
    
    // MARK: - View Models
    func makeHomeViewModel(actions: HomeViewModelActions) -> HomeViewModel {
        return DefaultHomeViewModel(
            getUserDataUseCase: makeGetCurrentUserUseCase(),
            actions: actions
        )
    }
    
//    func makeHomeQueryListViewModel(didSelect: @escaping HomeQueryListViewModelDidSelectAction) -> HomeQueryListViewModel {
//        DefaultHomeQueryListViewModel(
//            numberOfQueriesToShow: 10,
//            fetchRecentHomeQueriesUseCaseFactory: makeFetchRecentMovieQueriesUseCase,
//            didSelect: didSelect
//        )
//    }
    
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
    
//    @available(iOS 13.0, *)
//    func makeHomeQueryListViewModelWrapper(
//        didSelect: @escaping HomeQueryListViewModelDidSelectAction
//    ) -> HomeQueryListViewModelWrapper {
//        HomeQueryListViewModelWrapper(
//            viewModel: makeMoviesQueryListViewModel(didSelect: didSelect)
//        )
//    }
    
    // MARK: - View Controllers
    func makeHomeViewController(actions: HomeViewModelActions) -> HomeViewController {
        return HomeViewController.create(
            with: makeHomeViewModel(actions: actions)
        )
    }
    
//    func makeHomeQueriesSuggestionsListViewController(didSelect: @escaping HomeQueryListViewModelDidSelectAction) -> UIViewController {
//        if #available(iOS 13.0, *) { // SwiftUI
//            let view = HomeQueryListView(
//                viewModelWrapper: makeMoviesQueryListViewModelWrapper(didSelect: didSelect)
//            )
//            return UIHostingController(rootView: view)
//        } else { // UIKit
//            return MoviesQueriesTableViewController.create(
//                with: makeMoviesQueryListViewModel(didSelect: didSelect)
//            )
//        }
//    }
    
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
