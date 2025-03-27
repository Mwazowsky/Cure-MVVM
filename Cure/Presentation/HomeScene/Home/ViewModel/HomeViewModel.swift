import Foundation
import UIKit

struct HomeViewModelActions {
    //    let showHomeQueriesSuggestions: (@escaping (_ didSelect: HomeQuery) -> Void) -> Void
    //    let closeHomeQueriesSuggestions: () -> Void
}

enum HomeViewModelLoading {
    case fullScreen
    case nextPage
}

protocol HomeViewModelInput {
    func viewDidLoad()
    func didSearch(query: String)
    func didCancelSearch()
    //    func showQueriesSuggestions()
    //    func closeQueriesSuggestions()
}

protocol HomeViewModelOutput {
    var loading: Observable<HomeViewModelLoading?> { get }
    var query: Observable<String> { get }
    var error: Observable<String> { get }
    var screenTitle: String { get }
    var emptyDataTitle: String { get }
    var errorTitle: String { get }
    var searchBarPlaceholder: String { get }
    var tabs: [UIViewController] { get }
}

typealias HomeViewModel = HomeViewModelInput & HomeViewModelOutput

final class DefaultHomeViewModel: HomeViewModel {
    //    private let homeUseCase: HomeUseCase
    private let actions: HomeViewModelActions?
    
    // External Use Case
    private let getUserDataUseCase: GetUserUseCase
    
    private var homeLoadTask: Cancellable? { willSet { homeLoadTask?.cancel() } }
    private let mainQueue: DispatchQueueType
    
    // MARK: - OUTPUT
    let loading: Observable<HomeViewModelLoading?> = Observable(.none)
    let query: Observable<String> = Observable("")
    let error: Observable<String> = Observable("")
    let screenTitle = NSLocalizedString("Home", comment: "")
    let emptyDataTitle = NSLocalizedString("Search results", comment: "")
    let errorTitle = NSLocalizedString("Error", comment: "")
    let searchBarPlaceholder = NSLocalizedString("Search Chat", comment: "")
    
    var tabs: [UIViewController] {
        let homeViewController = HomeViewController()
        let movieListViewController = MoviesListViewController()

        return [
            createNavigationController(for: homeViewController, title: "Home", image: getImage(named: "house")),
            createNavigationController(for: movieListViewController, title: "Profile", image: getImage(named: "person"))
        ]
    }

    /// Helper function to support both SF Symbols (iOS 13+) and asset images (iOS 12 and below)
    private func getImage(named name: String) -> UIImage? {
        if #available(iOS 13.0, *) {
            return UIImage(systemName: name) ?? UIImage(named: name)
        } else {
            return UIImage(named: name)
        }
    }
    
    // MARK: - Init
    
    init(
        //        homeUseCase: HomeUseCase,
        getUserDataUseCase: GetUserUseCase,
        actions: HomeViewModelActions? = nil,
        mainQueue: DispatchQueueType = DispatchQueue.main
    ) {
        //        self.homeUseCase = homeUseCase
        self.getUserDataUseCase = getUserDataUseCase
        self.actions = actions
        self.mainQueue = mainQueue
    }
    
    private func handle(error: Error) {
        self.error.value = error.isInternetConnectionError ?
        NSLocalizedString("No internet connection", comment: "") :
        NSLocalizedString("Failed loading movies", comment: "")
    }
    
    private func createNavigationController(for viewController: UIViewController,
                                            title: String,
                                            image: UIImage?) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.tabBarItem.title = title
        navigationController.tabBarItem.image = image
        return navigationController
    }
}

// MARK: - INPUT. View event methods

extension DefaultHomeViewModel {
    
    func viewDidLoad() {
        print("Get Saved User Data: ", getUserDataUseCase.execute() as Any)
    }
    
    func didLoadNextPage() {
        print("Next Page Loaded...")
    }
    
    func didSearch(query: String) {
        guard !query.isEmpty else { return }
    }
    
    func didCancelSearch() {
        homeLoadTask?.cancel()
    }
    
    func showQueriesSuggestions() {
        //        actions?.showMovieQueriesSuggestions(update(homeQuery:))
        print("Show Query Suggestion Shown")
    }
    
    func closeQueriesSuggestions() {
        //        actions?.closeHomeQueriesSuggestions()
        print("Show Query Suggestion Closed")
    }
}
