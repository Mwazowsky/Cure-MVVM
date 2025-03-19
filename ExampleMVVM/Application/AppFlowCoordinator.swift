import UIKit

final class AppFlowCoordinator {
    
    var navigationController: UINavigationController
    private let appDIContainer: AppDIContainer
    
    init(
        navigationController: UINavigationController,
        appDIContainer: AppDIContainer
    ) {
        self.navigationController = navigationController
        self.appDIContainer = appDIContainer
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
        authFlow.start()
    }
    
    
    private func showMoviesFlow() {
        let moviesSceneDIContainer = appDIContainer.makeMoviesSceneDIContainer()
        let moviesFlow = moviesSceneDIContainer.makeMoviesSearchFlowCoordinator(
            navigationController: navigationController
        )
        moviesFlow.start()
    }
}


extension AppFlowCoordinator: AuthFlowCoordinatorDelegate {
    func authFlowDidFinish(with user: LoginResponse) {
        showMoviesFlow()
    }
}
