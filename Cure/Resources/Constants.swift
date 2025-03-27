//
//  Constants.swift
//  Cure
//
//  Created by MacBook Air MII  on 27/3/25.
//

import Foundation
import Alamofire

let appStoreID = "6642695368"

struct Constants {
    static private let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
    static private let appBundle = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "Unknown"
    static private let appName = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String ?? "Unknown"
    static let maxFileSize = 5.0
    
    static func getName() -> String { return "\(appName) \("versi".localiz()) \(appVersion)" }
}


struct Connectivity {
    static let sharedInstance = NetworkReachabilityManager()!
    static var isConnectedToInternet:Bool {
        return self.sharedInstance.isReachable
    }
}

enum typeUpdateApps {
    case force
    case later
}
