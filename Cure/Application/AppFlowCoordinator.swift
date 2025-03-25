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
    private let getUserDataUseCase: GetUserUseCase
    
    init(
        navigationController: UINavigationController,
        appDIContainer: AppDIContainer
    ) {
        self.navigationController = navigationController
        self.appDIContainer = appDIContainer
        self.windowManager = appDIContainer.makeWindowManager()
        self.getUserDataUseCase = appDIContainer.makeMoviesSceneDIContainer().makeGetCurrentUserUseCase()
    }
    
    func start() {
        let userData = getUserDataUseCase.execute()
        handlingNavigation(token: userData?.token)
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
        
        windowManager.changeRootViewController(to: newNavigationController, animated: false)
        childCoordinators.removeAll()
        childCoordinators.append(moviesFlow)
        
        moviesFlow.parentCoordinator = self
        
        moviesFlow.start()
    }
    
    
    func handlingNavigation(token: String?) {
        if let token = token,
           !token.isEmpty,
           token.trimmingCharacters(in: .whitespacesAndNewlines).count > 0 {
            showMoviesFlow()
        } else {
            showAuthFlow()
        }
    }
}


extension AppFlowCoordinator: AuthFlowCoordinatorDelegate {
    func authFlowDidFinish(with user: LoginResponse) {
        showMoviesFlow()
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
