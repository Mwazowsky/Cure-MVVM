//
//  DeviceInfoRepository.swift
//  Cure
//
//  Created by MacBook Air MII  on 2/4/25.
//

protocol IDeviceInfoRepository {
    var platform: String { get }
    var version: String { get }
    var manufacturer: String { get }
    var model: String { get }
    var serial: String { get }
    var fcmToken: String { get }
}
