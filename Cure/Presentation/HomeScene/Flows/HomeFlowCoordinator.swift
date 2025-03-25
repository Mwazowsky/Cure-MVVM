import UIKit

protocol HomeFlowCoordinatorDependencies  {
    func makeHomeViewController(
        actions: HomeViewModelActions
    ) -> HomeViewController
    
    func makeHomeQueriesSuggestionsListViewController(
        didSelect: @escaping MoviesQueryListViewModelDidSelectAction
    ) -> UIViewController
}

protocol HomeFlowCoordinatorDelegate: AnyObject {
    func homeFlowDidFinish(with user: LoginResponse)
}

final class HomeFlowCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = [Coordinator]()
    
    weak var navigationController: UINavigationController?
    private let dependencies: HomeFlowCoordinatorDependencies
    private weak var delegate: HomeFlowCoordinatorDelegate?

    weak var parentCoordinator: AppFlowCoordinator?
    private weak var homeVC: HomeViewController?
    private weak var homeSearchSuggestionsVC: UIViewController?

    init(
        navigationController: UINavigationController,
         dependencies: HomeFlowCoordinatorDependencies,
        delegate: HomeFlowCoordinatorDelegate? = nil
    ) {
        self.navigationController = navigationController
        self.dependencies = dependencies
        self.delegate = delegate
    }
    
    func start() {
        // Note: here we keep strong reference with actions, this way this flow do not need to be strong referenced
        let actions = HomeViewModelActions(showHomeQueriesSuggestions: <#(@escaping (MovieQuery) -> Void) -> Void#>, closeMovieQueriesSuggestions: <#() -> Void#>)
        let vc = dependencies.makeHomeViewController(actions: actions)
        navigationController?.pushViewController(vc, animated: false)
        homeVC = vc
    }
    
    func finish() {
        print("Entered HomeFlowCoordinator > Finish")
        parentCoordinator?.childDidFinish(self)
    }
    
    
    private func showMovieQueriesSuggestions(didSelect: @escaping (MovieQuery) -> Void) {
        guard let homeViewController = homeVC, homeSearchSuggestionsVC == nil,
            let container = homeViewController.suggestionsListContainer else { return }

        let vc = dependencies.makeHomeQueriesSuggestionsListViewController(didSelect: didSelect)

        homeViewController.add(child: vc, container: container)
        homeSearchSuggestionsVC = vc
        container.isHidden = false
    }
}
