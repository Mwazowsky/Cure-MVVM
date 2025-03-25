import UIKit

protocol HomeFlowCoordinatorDependencies  {
    func makeHomeViewController(
        actions: HomeViewModelActions
    ) -> HomeViewController
}

final class HomeFlowCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = [Coordinator]()
    
    weak var navigationController: UINavigationController?
    private let dependencies: HomeFlowCoordinatorDependencies

    weak var parentCoordinator: AppFlowCoordinator?
    private weak var homeVC: HomeViewController?
    private weak var homeSearchSuggestionsVC: UIViewController?

    init(navigationController: UINavigationController,
         dependencies: HomeFlowCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
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
}
