import UIKit

protocol HomeFlowCoordinatorDependencies  {
    func makeHomeViewController(
        actions: HomeViewModelActions
    ) -> HomeViewController
}

protocol HomeFlowCoordinatorDelegate: AnyObject {
    func homeFlowDidFinish(with user: LoginResponse)
}

protocol HomeFlowCoordinatorProtocol: Coordinator {
    var tabBarController: UITabBarController { get set }
    func selectItem(_ item: TabBarItem)
    func setSelectedIndex(_ index: Int)
    func currentItem() -> TabBarItem?
}

enum TabBarItem {
    case ready
    case steady
    case go
    
    init?(index: Int) {
        switch index {
        case 0:
            self = .ready
        case 1:
            self = .steady
        case 2:
            self = .go
        default:
            return nil
        }
    }
    
    func pageeTitleValue() -> String {
        switch self {
        case .ready:
            return "Ready"
        case .steady:
            return "Steady"
        case .go:
            return "Go"
        }
    }
    
    func pageOrderNumber() -> Int {
        switch self {
        case .ready:
            return 0
        case .steady:
            return 1
        case .go:
            return 2
        }
    }
    
    func pageIconName() -> String {
        switch self {
        case .ready:
            return "square.and.arrow.down.fill"
        case .steady:
            return "pencil.circle.fill"
        case .go:
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
    var childCoordinators: [Coordinator] = [Coordinator]()
    var type: CoordinatorType { .tab }
    
    weak var navigationController: UINavigationController?
    
    var tabBarController: UITabBarController
    
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
        self.tabBarController = .init()
    }
    
    deinit {
        print("HomeFLowCoordinator deinit'd")
    }
    
    func start() {
        // Globally set the navbar hiden or visible
        navigationController?.navigationBar.isHidden = false
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        let pages: [TabBarItem] = [.go, .steady, .ready]
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
        
        tabBarController.selectedIndex = TabBarItem.ready.pageOrderNumber()
        
        tabBarController.tabBar.isTranslucent = false
        
        navigationController?.viewControllers = [tabBarController]
    }
    
    private func getTabBarController(_ item: TabBarItem) -> UINavigationController {
        let navController = UINavigationController()
        
        // View Based set the navbar hidden or visible/potentially diferent navbar type for different tab?
        navController.setNavigationBarHidden(true, animated: false)
        
        navController.tabBarItem = UITabBarItem.init(
            title: item.pageeTitleValue(),
            image: item.pageIconValue(),
            tag: item.pageOrderNumber()
        )
        
        switch item {
        case .ready:
            let readyVC = ReadyViewController()
            readyVC.didSendEventClosure = { [weak self] event in
                switch event {
                case .ready:
                    self?.selectItem(.ready)
                }
            }
            
            navController.viewControllers = [readyVC]
            
        case .steady:
            let steadyVC = SteadyViewController()
            steadyVC.didSendEventClosure = { [weak self] event in
                switch event {
                case .steady:
                    self?.selectItem(.steady)
                }
            }
            
            navController.viewControllers = [steadyVC]
            
        case .go:
            let goVC = GoViewController()
            goVC.didSendEventClosure = { [weak self] event in
                switch event {
                case .goEvent:
                    self?.selectItem(.go)
                }
            }

            navController.viewControllers = [goVC]
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
        print("did select")
    }
}
