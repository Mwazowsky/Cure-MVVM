//
//  DefaultDeviceInfoRepository.swift
//  Cure
//
//  Created by MacBook Air MII  on 2/4/25.
//

import UIKit

class DefaultDeviceInfoRepository: IDeviceInfoRepository {
    var platform: String {
        UIDevice.current.systemName
    }
    
    var version: String {
        UIDevice.current.systemVersion
    }
    
    var manufacturer: String {
        "Apple"
    }
    
    var model: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }
    
    var serial: String {
        UIDevice.current.identifierForVendor?.uuidString ?? "unknown"
    }
    
    var fcmToken: String {
        // Get from your Firebase Messaging setup
        UserDefaults.standard.string(forKey: "fcmToken") ?? ""
    }
    
    func deviceDetail() -> DeviceModel {
        return DeviceModel(
            platform: platform,
            version: version,
            manufacturer: manufacturer,
            model: model,
            serial: serial
        )
    }
    
    
    fileprivate func getDeviceIdentifier() -> String {
           var systemInfo = utsname()
           uname(&systemInfo)
           let machineMirror = Mirror(reflecting: systemInfo.machine)
           let identifier = machineMirror.children.reduce("") { identifier, element in
               guard let value = element.value as? Int8, value != 0 else { return identifier }
               return identifier + String(UnicodeScalar(UInt8(value)))
           }
           return identifier
       }
       
       fileprivate func deviceName(for identifier: String) -> String? {
           // Mapping of device identifiers to device names
           let deviceMap = [
               "iPhone14,2": "iPhone 13 Pro",
               "iPhone14,3": "iPhone 13 Pro Max",
               "iPhone14,4": "iPhone 13 mini",
               "iPhone14,5": "iPhone 13",
               // Add more device identifiers and names as needed
           ]
           return deviceMap[identifier]
       }
}
