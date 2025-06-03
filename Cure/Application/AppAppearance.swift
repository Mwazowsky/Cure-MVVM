import UIKit

final class AppAppearance {
    // Setup Navigation Bar Appearance here
    static func setupAppearance() {
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            
            appearance.titleTextAttributes = [
                .foregroundColor: DesignTokens.LegacyColors.lightBackground
            ]
            
            appearance.largeTitleTextAttributes = [
                .foregroundColor: DesignTokens.LegacyColors.lightBackground
            ]
            
            appearance.backgroundColor = DesignTokens.LegacyColors.primary
            appearance.shadowImage = UIImage()
            appearance.shadowColor = .clear
            UINavigationBar.appearance().tintColor = DesignTokens.LegacyColors.lightBackground
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        } else {
            UINavigationBar.appearance().barTintColor = DesignTokens.LegacyColors.primary
            UINavigationBar.appearance().tintColor = DesignTokens.LegacyColors.lightBackground
            UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        }
    }
}

extension UINavigationController {
    @objc override open var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
