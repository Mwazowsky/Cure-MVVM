import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController? { get set }
    
    func start()
}

final class AppFlowCoordinator {
    var childCoordinators: [Coordinator]  = [Coordinator]()
    
    var navigationController: UINavigationController
    private let appDIContainer: AppDIContainer
    private let windowManager: WindowManageable
    
    init(
        navigationController: UINavigationController,
        appDIContainer: AppDIContainer
    ) {
        self.navigationController = navigationController
        self.appDIContainer = appDIContainer
        self.windowManager = appDIContainer.makeWindowManager()
    }
    
    func start() {
        showAuthFlow()
    }
    
    private func showAuthFlow() {
        let authSceneDIContainer = appDIContainer.makeAuthSceneDIContainer()
        let authFlow = authSceneDIContainer.makeAuthFlowCoordinator(
            navigationController: navigationController,
            delegate: self
        )
        
        childCoordinators.append(authFlow)
        
        authFlow.parentCoordinator = self
        
        authFlow.start()
    }
    
    
    private func showMoviesFlow() {
        let newNavigationController = UINavigationController()
        
        let moviesSceneDIContainer = appDIContainer.makeMoviesSceneDIContainer()
        let moviesFlow = moviesSceneDIContainer.makeMoviesSearchFlowCoordinator(
            navigationController: newNavigationController
        )
        
        windowManager.changeRootViewController(to: newNavigationController, animated: true)
        childCoordinators.removeAll()
        childCoordinators.append(moviesFlow)
        
        moviesFlow.parentCoordinator = self
        
        moviesFlow.start()
    }
}


extension AppFlowCoordinator: AuthFlowCoordinatorDelegate {
    func authFlowDidFinish(with user: LoginResponse) {
        showMoviesFlow()
        print("child coordinators: \(childCoordinators)")
    }
    
    func childDidFinish(_ child: Coordinator?) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
}
