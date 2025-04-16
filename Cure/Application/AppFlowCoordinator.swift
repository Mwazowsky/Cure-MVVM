import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController? { get set }
    
    var type: CoordinatorType { get }
    
    func start()
}

// MARK: - CoordinatorType
enum CoordinatorType {
    case app, login, tab
}

final class AppFlowCoordinator {
    var childCoordinators: [Coordinator]  = [Coordinator]()
    
    var navigationController: UINavigationController
    private let appDIContainer: AppDIContainer
    private let windowManager: WindowManageable
    
    let getUserTokenDataUseCase: GetUserTokenUseCase
    
    init(
        navigationController: UINavigationController,
        appDIContainer: AppDIContainer
    ) {
        self.navigationController = navigationController
        self.appDIContainer = appDIContainer
        self.windowManager = appDIContainer.makeWindowManager()
        self.getUserTokenDataUseCase = appDIContainer.makeHomeSceneDIContainer().makeGetCurrentUserTokenUseCase()
    }
    
    func start() {
        let userTokenData = getUserTokenDataUseCase.execute()
        handlingNavigation(token: userTokenData?.token)
    }
    
    private func showAuthFlow() {
        print("Show Auth")
        let authSceneDIContainer = appDIContainer.makeAuthSceneDIContainer()
        let authFlow = authSceneDIContainer.makeAuthFlowCoordinator(
            navigationController: navigationController,
            delegate: self
        )
        
        windowManager.changeRootViewController(to: navigationController, animated: false)
        
        childCoordinators.append(authFlow)
        
        authFlow.parentCoordinator = self
        
        authFlow.start()
    }
    
    
    private func showHomeFlow() {
        let newNavigationController = UINavigationController()
        
        let homeSceneDIContainer = appDIContainer.makeHomeSceneDIContainer()
        let homeFlow = homeSceneDIContainer.makeHomeFlowCoordinator(
            navigationController: newNavigationController
        )
        
        windowManager.changeRootViewController(to: newNavigationController, animated: false)
        childCoordinators.removeAll()
        childCoordinators.append(homeFlow)
        
        homeFlow.parentCoordinator = self
        
        homeFlow.start()
    }
    
    
    func handlingNavigation(token: String?) {
        if let token = token,
           !token.isEmpty,
           token.trimmingCharacters(in: .whitespacesAndNewlines).count > 0 {
            showHomeFlow()
        } else {
            showAuthFlow()
        }
    }
}


extension AppFlowCoordinator: AuthFlowCoordinatorDelegate {
    func authFlowDidFinish(with user: UserDetailsDM) {
        showHomeFlow()
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
