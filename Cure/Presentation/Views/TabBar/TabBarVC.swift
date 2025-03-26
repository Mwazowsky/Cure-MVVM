//
//  TabBarVC.swift
//  UIkitZeroToHero
//
//  Created by Saifulloh Fadli on 01/02/25.
//

import UIKit

@available(iOS 13.0, *)
class TabBarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        super.loadView()
        setValue(TabBarView(), forKey: "tabBar")
    }
    
    func createSearchNavigationController() -> UINavigationController {
        let searchVC = HomeViewController()
        searchVC.title = "Search"
        
        let searchItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
//        searchItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        
        searchVC.tabBarItem = searchItem
        
        return UINavigationController(rootViewController: searchVC)
    }


    func createFavoritesNavigationController() -> UINavigationController {
        let favoriteVC = MoviesListViewController()
        favoriteVC.title = "Favorites"
        
        let favoritesItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
//        favoritesItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        
        favoriteVC.tabBarItem = favoritesItem
        
        return UINavigationController(rootViewController: favoriteVC)
    }
    
    
    func createTabBar() -> UITabBarController {
        let tabBarController = UITabBarController()

        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithTransparentBackground()
            appearance.backgroundEffect = UIBlurEffect(style: .systemChromeMaterial)
            appearance.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.2)
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        } else {
            UITabBar.appearance().backgroundImage = UIImage()
            UITabBar.appearance().shadowImage = UIImage()
        }
        
        UITabBar.appearance().tintColor = .systemGreen
        UITabBar.appearance().isTranslucent = true

        tabBarController.viewControllers = [
            createSearchNavigationController(),
            createFavoritesNavigationController()
        ]
        
        return tabBarController
    }

}
