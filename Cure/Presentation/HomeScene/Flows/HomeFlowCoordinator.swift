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

enum TabBarItem {
    case dashboard
    case chats
    case account
    
    init?(index: Int) {
        switch index {
        case 0:
            self = .dashboard
        case 1:
            self = .chats
        case 2:
            self = .account
        default:
            return nil
        }
    }
    
    func pageeTitleValue() -> String {
        switch self {
        case .dashboard:
            return "Dashboard"
        case .chats:
            return "Chats"
        case .account:
            return "Account"
        }
    }
    
    func pageOrderNumber() -> Int {
        switch self {
        case .dashboard:
            return 0
        case .chats:
            return 1
        case .account:
            return 2
        }
    }
    
    func pageIconName() -> String {
        switch self {
        case .dashboard:
            return "square.and.arrow.down.fill"
        case .chats:
            return "pencil.circle.fill"
        case .account:
            return "eraser.line.dashed.fill"
        }
    }
    
    func pageIconValue() -> UIImage? {
        if #available(iOS 13.0, *) {
            return UIImage(systemName: pageIconName())
        } else {
            return UIImage(named: pageIconName())
        }
    }
    
    func iconSelectedColor() -> UIColor {
        return .systemBlue
    }
}

final class HomeFlowCoordinator: NSObject, HomeFlowCoordinatorProtocol {
    private let appDIContainer: AppDIContainer
    
    var childCoordinators: [Coordinator] = [Coordinator]()
    var type: CoordinatorType { .tab }
    
    weak var navigationController: UINavigationController?
    
    var tabBarController: UITabBarController
    
    private let dependencies: HomeFlowCoordinatorDependencies
    private weak var delegate: HomeFlowCoordinatorDelegate?
    
    weak var parentCoordinator: AppFlowCoordinator?
    private weak var homeVC: HomeViewController?
    private weak var homeSearchSuggestionsVC: UIViewController?
    
    private let windowManager: WindowManageable
    
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
        print("HomeFLowCoordinator deinit'd")
    }
    
    func start() {
        // Globally set the navbar hiden or visible
        navigationController?.navigationBar.isHidden = true
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        let pages: [TabBarItem] = [.dashboard, .chats, .account]
            .sorted(by: {$0.pageOrderNumber() < $1.pageOrderNumber()})
        
        let controllers: [UINavigationController] = pages.map({ getTabBarController($0) })
        
        prepareTabBarController(withTabBarControllers: controllers)
    }
    
    func finish() {
        print("Entered HomeFlowCoordinator > Finish")
        parentCoordinator?.childDidFinish(self)
    }
    
    private func prepareTabBarController(withTabBarControllers tabBarControllers: [UIViewController]) {
        tabBarController.delegate = self
        
        tabBarController.setViewControllers(tabBarControllers, animated: true)
        
        tabBarController.selectedIndex = TabBarItem.chats.pageOrderNumber()
        
        tabBarController.tabBar.isTranslucent = true
        
        tabBarController.tabBar.tintColor = .primaryRed
        
        navigationController?.viewControllers = [tabBarController]
    }
    
    private func showMovieFlow(navigationController: UINavigationController) {
        let moviesSceneDIContainer = appDIContainer.makeMoviesSceneDIContainer()
        let moviesFlowCoordinator = moviesSceneDIContainer.makeMoviesSearchFlowCoordinator(
            navigationController: navigationController
        )
        
        moviesFlowCoordinator.parentCoordinator = self
        moviesFlowCoordinator.start()
        
        childCoordinators.append(moviesFlowCoordinator)
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
    
    private func showForgotPassword() {
        //        let vc = dependencies.makeMoviesDetailsViewController(movie: movie)
        //        navigationController?.pushViewController(vc, animated: true)
    }
    
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
            showMovieFlow(navigationController: navController)
        case .account:
            showAccountFlow(navigationController: navController)
        }
        
        return navController
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

// MARK: - UITabBarControllerDelegate
extension HomeFlowCoordinator: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController,
                          didSelect viewController: UIViewController) {
        UIView.setAnimationsEnabled(false)
    }
}

extension HomeFlowCoordinator: HomeFlowCoordinatorDelegate {
    func homeFlowDidFinish() {
        print("Executing start")
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
