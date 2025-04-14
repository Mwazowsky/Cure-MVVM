//
//  SceneDelegate.swift
//  Cure
//
//  Created by MacBook Air MII  on 14/4/25.
//

import UIKit
import LanguageManager_iOS
import GoogleMaps
import GooglePlaces
import AVFAudio
import Firebase
import FirebaseMessaging

@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var appFlowCoordinator: AppFlowCoordinator? // Main Coordinator
    
    private var socketService: SocketService!
    private var keychainService: DefaultKeychainRepository!
    
    var window: UIWindow?
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        AppAppearance.setupAppearance()
        
        window = UIWindow(windowScene: windowScene)
        
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
        appFlowCoordinator?.start()
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        let userTokenData = appFlowCoordinator?.getUserTokenDataUseCase.execute()
        let isHasToken = userTokenData != nil
        if !isHasToken { return }
        if socketService.socketStatus() == .disconnected ||
            socketService.socketStatus() == .notConnected {
            socketService.connect(from: "SceneDelegate")
        }
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        CoreDataStorage.shared.saveContext()
        let userTokenData = appFlowCoordinator?.getUserTokenDataUseCase.execute()
        let isHasToken = userTokenData != nil
        if !isHasToken { return }
        socketService.disconnect()
    }
}

@available(iOS 13.0, *)
extension SceneDelegate: MessagingDelegate, UNUserNotificationCenterDelegate {
    func setupGoogleMaps() {
        GMSServices.provideAPIKey("AIzaSyCUbt0Kjb08PkDsUnDzAOCDegGJLZsexsg")
        GMSPlacesClient.provideAPIKey("AIzaSyCUbt0Kjb08PkDsUnDzAOCDegGJLZsexsg")
    }
    
    /// Mark: Messaging Delegate
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let fcmToken = fcmToken else { return }
        let isFCMSaved = keychainService.saveFCMTokenData(fcmToken)
        print(isFCMSaved)
    }
    
    /// Mark: Messaging UNUserNotificationCenterDelegate
    
    func registerForPushNotifications() {
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
//                    
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
//            
//            self.window?.rootViewController = navController
            
            break
        }
    }
}
