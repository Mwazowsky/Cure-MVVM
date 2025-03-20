import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var appFlowCoordinator: AppFlowCoordinator? // Main Coordinator
    
    var window: UIWindow?
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        AppAppearance.setupAppearance()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let windowManager = WindowManager(window: window!)
        
        let navigationController = UINavigationController()
        let appDIContainer = AppDIContainer(windowManager: windowManager)
        
        appFlowCoordinator = AppFlowCoordinator(
            navigationController: navigationController,
            appDIContainer: appDIContainer
        )
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        appFlowCoordinator?.start()
    
        return true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        CoreDataStorage.shared.saveContext()
    }
    
    func handlingNavigation(token: Bool) {
        if (token == true) {
            let vc = MoviesListViewController()
            let navigationController = UINavigationController(rootViewController: vc)
            self.window?.rootViewController = navigationController
        } else {
            let vc = LoginViewController()
            let navigationController = UINavigationController(rootViewController: vc)
            self.window?.rootViewController = navigationController
        }
    }
}
