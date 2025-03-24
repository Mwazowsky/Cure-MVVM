//
//  WindowManager.swift
//  ExampleMVVM
//
//  Created by MacBook Air MII  on 20/03/25.
//

import Foundation
import UIKit

protocol WindowManageable {
    func changeRootViewController(to viewController: UIViewController, animated: Bool)
}

class WindowManager: WindowManageable {
    private weak var window: UIWindow?
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func changeRootViewController(to viewController: UIViewController, animated: Bool) {
        guard let window = window else { return }
        
        if animated {
            let transition = CATransition()
            transition.type = .moveIn
            transition.duration = 0.3
            window.layer.add(transition, forKey: kCATransition)
        }
        
        window.rootViewController = viewController
    }
}
