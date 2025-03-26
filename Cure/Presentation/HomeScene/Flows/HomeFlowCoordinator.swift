import UIKit

protocol HomeFlowCoordinatorDependencies  {
    func makeHomeViewController(
        actions: HomeViewModelActions
    ) -> HomeViewController
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
        let actions = HomeViewModelActions()
        let vc = dependencies.makeHomeViewController(actions: actions)
        navigationController?.pushViewController(vc, animated: false)
//        navigationController?.navigationBar.isHidden = true
//        navigationController?.setNavigationBarHidden(true, animated: false)
        homeVC = vc
    }
    
    func finish() {
        print("Entered HomeFlowCoordinator > Finish")
        parentCoordinator?.childDidFinish(self)
    }
}
