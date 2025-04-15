import UIKit
import LanguageManager_iOS
import GoogleMaps
import GooglePlaces
import AVFAudio
import Firebase
import FirebaseMessaging

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var appFlowCoordinator: AppFlowCoordinator?
    
    private var socketService: SocketService!
    private var keychainService: DefaultKeychainRepository!
    
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
        
        socketService = appDIContainer.socketService
        keychainService = appDIContainer.keychainService
        
        appFlowCoordinator = AppFlowCoordinator(
            navigationController: navigationController,
            appDIContainer: appDIContainer
        )
        
        LanguageManager.shared.defaultLanguage = .id
        registerForPushNotifications()
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        self.setupGoogleMaps()
        
        appFlowCoordinator?.start()
        
        return true
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        let userTokenData = appFlowCoordinator?.getUserTokenDataUseCase.execute()
        let isHasToken = userTokenData != nil
        if #available(iOS 13, *) { return }
        else if !isHasToken { return }
        
        if socketService.socketStatus() == .disconnected ||
            socketService.socketStatus() == .notConnected {
            socketService.connect(from: "SceneDelegate")
        }
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        CoreDataStorage.shared.saveContext()
        let userTokenData = appFlowCoordinator?.getUserTokenDataUseCase.execute()
        let isHasToken = userTokenData != nil
        if #available(iOS 13, *) { return }
        else if !isHasToken { return }
        socketService.disconnect()
    }
}

extension AppDelegate: MessagingDelegate, UNUserNotificationCenterDelegate {
    func setupGoogleMaps() {
        GMSServices.provideAPIKey("AIzaSyCUbt0Kjb08PkDsUnDzAOCDegGJLZsexsg")
        GMSPlacesClient.provideAPIKey("AIzaSyCUbt0Kjb08PkDsUnDzAOCDegGJLZsexsg")
    }
    
    /// Mark: Messaging Delegate
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let fcmToken = fcmToken else { return }
        _ = keychainService.saveFCMTokenData(fcmToken)
    }
    
    /// Mark: Messaging UNUserNotificationCenterDelegate
    
    func registerForPushNotifications() {
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: { granted,error in
            
            guard granted else { return }
            
            
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        })
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        
        completionHandler([.alert, .badge, .sound])
        
        completionHandler([])
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        notificationHandler(userInfo: userInfo)
    }
    
    func notificationHandler(userInfo data: [AnyHashable:Any]) {
        let clickAction = data["click_action"] as? String
        switch clickAction {
        case "new-message":
            guard let messageNotifObject = data["message"], let stringData = "\(messageNotifObject)".data(using: .utf8) else  { return }
            do {
                let handledContact = keychainService.getHandledContactData()
                let dataMessage = try JSONDecoder().decode(NotifNewMessage.self, from: stringData)
                guard let handledData = handledContact?[dataMessage.companyHuntingNumberID] else { return }
                _ =  handledData.first(where: { $0.contactID == dataMessage.contactID })
                //                if let contact {
                //                    let tabBarVC = TabBarViewController()
                //                    let chattingVC = ChattingViewController()
                //                    chattingVC.pairingId = contact.contactPairingID
                //                    chattingVC.hidesBottomBarWhenPushed = true
                //                    let navController = UINavigationController(rootViewController: tabBarVC)
                //                    navController.pushViewController(chattingVC, animated: false)
                //                    self.window?.rootViewController = navController
                //                    return
                //                }
            } catch {
                return
            }
            break
        default:
            //            let tabBarVC = TabBarViewController()
            //            let navController = UINavigationController(rootViewController: tabBarVC)
            //            self.window?.rootViewController = navController
            break
        }
        
    }
}

struct NotifNewMessage: Decodable {
    let companyHuntingNumberID: Int
    let contactID: Int
    let contactPairingID: Int?
}
