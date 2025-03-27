import UIKit
import LanguageManager_iOS

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
        
        LanguageManager.shared.defaultLanguage = .id
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        appFlowCoordinator?.start()
    
        return true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        CoreDataStorage.shared.saveContext()
    }
}
