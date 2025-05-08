import UIKit
import SwiftUI

final class ChatContactsDIContainer: ChatContactsListFlowCoordinatorDependencies {
    
    struct Dependencies {
        let apiDataTransferService: DataTransferService
        let newApiDataTransferervice: DataTransferService
        let imageDataTransferService: DataTransferService
    }
    
    private let dependencies: Dependencies

    // MARK: - Persistent Storage
    /// ChatContacts
    lazy var chatContactsQueriesStorage: ChatContactsQueriesStorage  = CoreDataChatContactsQueriesStorage(maxStorageLimit: 10)
    lazy var chatContactsResponseCache : ChatContactsResponseStorage = CoreDataChatContactsResponseStorage()

    init(dependencies: Dependencies) {
        self.dependencies = dependencies        
    }
    
    // MARK: - Use Cases
//    func makeSearchMoviesUseCase() -> SearchMoviesUseCase {
//        DefaultSearchMoviesUseCase(
//            moviesRepository: makeMoviesRepository(),
//            moviesQueriesRepository: makeMoviesQueriesRepository()
//        )
//    }
    
    func makeFetchContactsUseCase() -> FetchChatContactsUseCase {
        DefaultFetchChatContactsUseCase(
            chatContactsRepository: makeChatContactsRepository(),
            chatsContactsQueriesRepository: makeChatContactsQueriesRepository()
        )
    }
    
//    func makeFetchRecentMovieQueriesUseCase(
//        requestValue: FetchRecentMovieQueriesUseCase.RequestValue,
//        completion: @escaping (FetchRecentMovieQueriesUseCase.ResultValue) -> Void
//    ) -> UseCase {
//        FetchRecentMovieQueriesUseCase(
//            requestValue: requestValue,
//            completion: completion,
//            moviesQueriesRepository: makeMoviesQueriesRepository()
//        )
//    }
    
    func makeGetCurrentUserTokenUseCase() -> GetUserTokenUseCase {
        return DefaultGetCurrentUserTokenUseCase(keychainRepository: makeKeychainRepository())
    }
    
    // MARK: - Repositories
    func makeChatContactsRepository() -> IChatContactsRepository {
        DefaultChatsRepository(
            newDataTransferService: dependencies.newApiDataTransferervice,
            cache: chatContactsResponseCache
        )
    }
    
    
    func makeChatContactsQueriesRepository() -> IChatContactsQueriesRepository {
        DefaultChatContactsQueriesRepository(
            chatContactsQueriesPersistentStorage: chatContactsQueriesStorage
        )
    }
    
    private func makeKeychainRepository() -> IKeychainRepository {
        return DefaultKeychainRepository()
    }

    
    // MARK: - Chat Contacts List
    func makeChatContactsListViewController(actions: ChatContactsListViewModelActions) -> ChatContactsListVC {
        ChatContactsListVC.create(
            with: makeChatContactsListViewModel(actions: actions)
        )
    }
    
    func makeChatContactsListViewModel(actions: ChatContactsListViewModelActions) -> ChatContactsViewModel {
        DefaultChatContactsViewModel(
            fetchChatContactsUseCase: makeFetchContactsUseCase(),
            getUserTokenDataUseCase: makeGetCurrentUserTokenUseCase(),
            actions: actions
        )
    }
    
    
    // MARK: - Movie Details
//    func makeMoviesDetailsViewController(movie: Movie) -> UIViewController {
//        MovieDetailsViewController.create(
//            with: makeMoviesDetailsViewModel(movie: movie)
//        )
//    }
//    
//    
//    func makeMoviesDetailsViewModel(movie: Movie) -> MovieDetailsViewModel {
//        DefaultMovieDetailsViewModel(
//            movie: movie,
//            posterImagesRepository: makePosterImagesRepository()
//        )
//    }
    
    
    // MARK: - Movies Queries Suggestions List
//    func makeMoviesQueriesSuggestionsListViewController(didSelect: @escaping MoviesQueryListViewModelDidSelectAction) -> UIViewController {
//        if #available(iOS 13.0, *) { // SwiftUI
//            let view = MoviesQueryListView(
//                viewModelWrapper: makeMoviesQueryListViewModelWrapper(didSelect: didSelect)
//            )
//            return UIHostingController(rootView: view)
//        } else { // UIKit
//            return MoviesQueriesTableViewController.create(
//                with: makeMoviesQueryListViewModel(didSelect: didSelect)
//            )
//        }
//    }
//    
//    
//    func makeMoviesQueryListViewModel(didSelect: @escaping MoviesQueryListViewModelDidSelectAction) -> MoviesQueryListViewModel {
//        DefaultMoviesQueryListViewModel(
//            numberOfQueriesToShow: 10,
//            fetchRecentMovieQueriesUseCaseFactory: makeFetchRecentMovieQueriesUseCase,
//            didSelect: didSelect
//        )
//    }

    
//    @available(iOS 13.0, *)
//    func makeMoviesQueryListViewModelWrapper(
//        didSelect: @escaping MoviesQueryListViewModelDidSelectAction
//    ) -> MoviesQueryListViewModelWrapper {
//        MoviesQueryListViewModelWrapper(
//            viewModel: makeMoviesQueryListViewModel(didSelect: didSelect)
//        )
//    }
    
    func makeChatContactsDetailsViewController(chatContact: ChatContact) -> UIViewController {
        print("Implement later: ", chatContact)
        
        return UIViewController()
    }
    
    func makeChattingViewController(chatContact: ChatContact) -> UIViewController {
        print("Implement later: ", chatContact)
        
        return UIViewController()
    }
    
    func makeChatContactsQueriesSuggestionsListViewController(didSelect: @escaping ChatContactsQueryListViewModelDidSelectAction) -> UIViewController {
        print("Implement later: ", didSelect)
        
        return UIViewController()
    }

    
    // MARK: - Flow Coordinators
    func makeChatContactsListFlowCoordinator(
        navigationController: UINavigationController
    ) -> ChatContactsListFlowCoordinator {
        ChatContactsListFlowCoordinator(
            navigationController: navigationController,
            dependencies: self
        )
    }
}
