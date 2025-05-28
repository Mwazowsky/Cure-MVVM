import UIKit

protocol HomeFlowCoordinatorDependencies  {
    func makeHomeViewController(
        actions: HomeViewModelActions
    ) -> HomeViewController
}

protocol HomeFlowCoordinatorDelegate: AnyObject {
    func homeFlowDidFinish()
}

protocol HomeFlowCoordinatorProtocol: Coordinator {
    var tabBarController: UITabBarController { get set }
    func selectItem(_ item: TabBarItem)
    func setSelectedIndex(_ index: Int)
    func currentItem() -> TabBarItem?
}

final class HomeFlowCoordinator: NSObject {
    // MARK: - Dependencies
    weak var navigationController   : UINavigationController?
    private let appDIContainer      : AppDIContainer
    private let dependencies        : HomeFlowCoordinatorDependencies
    private weak var delegate       : HomeFlowCoordinatorDelegate?
    private let windowManager       : WindowManageable
    
    // MARK: - Coordinators
    weak var parentCoordinator      : AppFlowCoordinator?
    var childCoordinators           : [Coordinator] = [Coordinator]()
    var type                        : CoordinatorType { .tab }
    
    // MARK: - Controllers
    var tabBarController          : UITabBarController
    private weak var homeVC       : HomeViewController?
    private weak var homeSearchVC : UIViewController?
    
    // MARK: - Base
    init(
        navigationController: UINavigationController,
        appDIContainer: AppDIContainer,
        dependencies: HomeFlowCoordinatorDependencies,
        delegate: HomeFlowCoordinatorDelegate? = nil
    ) {
        self.navigationController = navigationController
        self.appDIContainer = appDIContainer
        self.dependencies = dependencies
        self.delegate = delegate
        self.tabBarController = .init()
        self.windowManager = appDIContainer.windowManager
    }
    
    deinit {
        
    }
    
    func start() {
        navigationController?.navigationBar.isHidden = true
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        let pages: [TabBarItem] = [.dashboard, .chats, .account]
            .sorted(
                by: {$0.pageOrderNumber() < $1.pageOrderNumber()}
            )
        
        let controllers: [UINavigationController] = pages.map({ getTabBarController($0) })
        
        prepareTabBarController(withTabBarControllers: controllers)
    }
    
    func finish() {
        parentCoordinator?.childDidFinish(self)
    }
    
    // MARK: - Flow
    private func showChatContactsFlow(navigationController: UINavigationController) {
        let chatContactsSceneDIContainer = appDIContainer.makeChatContactsSceneDIContainer()
        let chatContactsFlowDIContainer = chatContactsSceneDIContainer.makeChatContactsListFlowCoordinator(
            navigationController: navigationController,
            appDIContainer: appDIContainer
        )
        
        chatContactsFlowDIContainer.parentCoordinator = self
        chatContactsFlowDIContainer.start()
        
        childCoordinators.append(chatContactsFlowDIContainer)
    }
    
    private func showAccountFlow(navigationController: UINavigationController) {
        let accountSceneDIContainer = appDIContainer.makeAccountSceneDIContainer()
        let accountFlowCoordinator = accountSceneDIContainer.makeAccountFlowCoordinator(
            navigationController: navigationController
        )
        
        accountFlowCoordinator.parentCoordinator = self
        accountFlowCoordinator.start()
        
        childCoordinators.append(accountFlowCoordinator)
    }
    
    private func showForgotPasswordFlow() {
//                let vc = dependencies.makeMoviesDetailsViewController(movie: movie)
//                navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - View
    private func getTabBarController(_ item: TabBarItem) -> UINavigationController {
        let navController = UINavigationController()
        
        navController.setNavigationBarHidden(false, animated: true)
        
        navController.tabBarItem = UITabBarItem.init(
            title: item.pageeTitleValue(),
            image: item.pageIconValue(),
            tag: item.pageOrderNumber()
        )
        
        switch item {
        case .dashboard:
            let dashboardVC = DashboardVC()
            dashboardVC.didSendEventClosure = { [weak self] event in
                switch event {
                case .dashboard:
                    self?.selectItem(.dashboard)
                }
            }
            
            navController.viewControllers = [dashboardVC]
        case .chats:
            showChatContactsFlow(navigationController: navController)
        case .account:
            showAccountFlow(navigationController: navController)
        }
        
        return navController
    }
    
    private func prepareTabBarController(withTabBarControllers tabBarControllers: [UIViewController]) {
        tabBarController.delegate = self
        tabBarController.setViewControllers(tabBarControllers, animated: true)
        tabBarController.selectedIndex = TabBarItem.chats.pageOrderNumber()
        tabBarController.tabBar.isTranslucent = true
        tabBarController.tabBar.tintColor = DesignTokens.LegacyColors.primary
        
        if #available(iOS 15.0, *) {
            let tabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithDefaultBackground()
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }
        
        navigationController?.viewControllers = [tabBarController]
    }
}


// MARK: - UITabBarControllerDelegate and Protocol
extension HomeFlowCoordinator: UITabBarControllerDelegate, HomeFlowCoordinatorProtocol {
    func tabBarController(_ tabBarController: UITabBarController,
                          didSelect viewController: UIViewController) {
        UIView.setAnimationsEnabled(false)
    }
    
    func selectItem(_ item: TabBarItem) {
        tabBarController.selectedIndex = item.pageOrderNumber()
    }
    
    func setSelectedIndex(_ index: Int) {
        guard let item = TabBarItem.init(index: index) else { return }
        
        tabBarController.selectedIndex = item.pageOrderNumber()
    }
    
    func currentItem() -> TabBarItem? {
        TabBarItem.init(index: tabBarController.selectedIndex)
    }
}

extension HomeFlowCoordinator: HomeFlowCoordinatorDelegate {
    func homeFlowDidFinish() {
        parentCoordinator?.start()
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
