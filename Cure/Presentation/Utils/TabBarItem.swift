//
//  TabBarItem.swift
//  Cure
//
//  Created by MacBook Air MII  on 22/5/25.
//

import UIKit

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
            return "Dashboard".localiz()
        case .chats:
            return "Chats".localiz()
        case .account:
            return "Account".localiz()
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
            return "IconTabDashboard"
        case .chats:
            return "IconTabChat"
        case .account:
            return "IconTabAccount"
        }
    }
    
    func pageIconValue() -> UIImage? {
            return UIImage(named: pageIconName())
    }
    
    func iconSelectedColor() -> UIColor {
        return .systemBlue
    }
}
