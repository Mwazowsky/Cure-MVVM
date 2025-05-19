import UIKit
import SwiftUI

final class MoviesSceneDIContainer: MoviesSearchFlowCoordinatorDependencies {
    
    struct Dependencies {
        let apiDataTransferService: DataTransferService
        let newApiDataTransferervice: DataTransferService
        let imageDataTransferService: DataTransferService
    }
    
    private let dependencies: Dependencies

    // MARK: - Persistent Storage
    lazy var moviesQueriesStorage: MoviesQueriesStorage  = CoreDataMoviesQueriesStorage(maxStorageLimit: 10)
    lazy var moviesResponseCache : MoviesResponseStorage = CoreDataMoviesResponseStorage()
    
    /// ChatContacts
    lazy var chatContactsQueriesStorage: ChatContactsQueriesStorage  = CoreDataChatContactsQueriesStorage(maxStorageLimit: 10)
    lazy var chatContactsResponseCache : ChatContactsResponseStorage = CoreDataChatContactsResponseStorage()

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    // MARK: - Use Cases
    func makeSearchMoviesUseCase() -> SearchMoviesUseCase {
        DefaultSearchMoviesUseCase(
            moviesRepository: makeMoviesRepository(),
            moviesQueriesRepository: makeMoviesQueriesRepository()
        )
    }
    
    func makeFetchContactsUseCase() -> FetchChatContactsUseCase {
        DefaultFetchChatContactsUseCase(
            chatContactsRepository: makeChatContactsRepository(),
            chatsContactsQueriesRepository: makeChatContactsQueriesRepository()
        )
    }
    
    func makeFetchRecentMovieQueriesUseCase(
        requestValue: FetchRecentMovieQueriesUseCase.RequestValue,
        completion: @escaping (FetchRecentMovieQueriesUseCase.ResultValue) -> Void
    ) -> UseCase {
        FetchRecentMovieQueriesUseCase(
            requestValue: requestValue,
            completion: completion,
            moviesQueriesRepository: makeMoviesQueriesRepository()
        )
    }
    
    func makeGetCurrentUserTokenUseCase() -> GetUserTokenUseCase {
        return DefaultGetCurrentUserTokenUseCase(keychainRepository: makeKeychainRepository())
    }
    
    // MARK: - Repositories
    func makeMoviesRepository() -> IMoviesRepository {
        DefaultMoviesRepository(
            dataTransferService: dependencies.apiDataTransferService,
            cache: moviesResponseCache
        )
    }
    
    func makeChatContactsRepository() -> IChatContactsRepository {
        DefaultChatContactsRepository(
            newDataTransferService: dependencies.newApiDataTransferervice,
            cache: chatContactsResponseCache
        )
    }
    
    
    func makeMoviesQueriesRepository() -> IMoviesQueriesRepository {
        DefaultMoviesQueriesRepository(
            moviesQueriesPersistentStorage: moviesQueriesStorage
        )
    }
    
    func makeChatContactsQueriesRepository() -> IChatContactsQueriesRepository {
        DefaultChatContactsQueriesRepository(
            chatContactsQueriesPersistentStorage: chatContactsQueriesStorage
        )
    }
    
    
    func makePosterImagesRepository() -> IPosterImagesRepository {
        DefaultPosterImagesRepository(
            dataTransferService: dependencies.imageDataTransferService
        )
    }
    
    private func makeKeychainRepository() -> IKeychainRepository {
        return DefaultKeychainRepository()
    }

    
    // MARK: - Movies List
    func makeMoviesListViewController(actions: MoviesListViewModelActions) -> MoviesListViewController {
        MoviesListViewController.create(
            with: makeMoviesListViewModel(actions: actions),
            posterImagesRepository: makePosterImagesRepository()
        )
    }
    
    func makeMoviesListViewModel(actions: MoviesListViewModelActions) -> MoviesListViewModel {
        DefaultMoviesListViewModel(
            searchMoviesUseCase: makeSearchMoviesUseCase(),
            getUserTokenDataUseCase: makeGetCurrentUserTokenUseCase(),
            actions: actions
        )
    }
    
    
    // MARK: - Movie Details
    func makeMoviesDetailsViewController(movie: Movie) -> UIViewController {
        MovieDetailsViewController.create(
            with: makeMoviesDetailsViewModel(movie: movie)
        )
    }
    
    
    func makeMoviesDetailsViewModel(movie: Movie) -> MovieDetailsViewModel {
        DefaultMovieDetailsViewModel(
            movie: movie,
            posterImagesRepository: makePosterImagesRepository()
        )
    }
    
    
    // MARK: - Movies Queries Suggestions List
    func makeMoviesQueriesSuggestionsListViewController(didSelect: @escaping MoviesQueryListViewModelDidSelectAction) -> UIViewController {
        if #available(iOS 13.0, *) { // SwiftUI
            let view = MoviesQueryListView(
                viewModelWrapper: makeMoviesQueryListViewModelWrapper(didSelect: didSelect)
            )
            return UIHostingController(rootView: view)
        } else { // UIKit
            return MoviesQueriesTableViewController.create(
                with: makeMoviesQueryListViewModel(didSelect: didSelect)
            )
        }
    }
    
    
    func makeMoviesQueryListViewModel(didSelect: @escaping MoviesQueryListViewModelDidSelectAction) -> MoviesQueryListViewModel {
        DefaultMoviesQueryListViewModel(
            numberOfQueriesToShow: 10,
            fetchRecentMovieQueriesUseCaseFactory: makeFetchRecentMovieQueriesUseCase,
            didSelect: didSelect
        )
    }

    
    @available(iOS 13.0, *)
    func makeMoviesQueryListViewModelWrapper(
        didSelect: @escaping MoviesQueryListViewModelDidSelectAction
    ) -> MoviesQueryListViewModelWrapper {
        MoviesQueryListViewModelWrapper(
            viewModel: makeMoviesQueryListViewModel(didSelect: didSelect)
        )
    }

    
    // MARK: - Flow Coordinators
    func makeMoviesSearchFlowCoordinator(
        navigationController: UINavigationController
    ) -> MoviesSearchFlowCoordinator {
        MoviesSearchFlowCoordinator(
            navigationController: navigationController,
            dependencies: self
        )
    }
}
