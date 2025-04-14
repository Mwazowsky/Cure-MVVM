//
//  Notification+Extension.swift
//  Cure
//
//  Created by MacBook Air MII  on 27/3/25.
//

import Foundation

extension Notification.Name {
    /// MARK: socket observer
    static let socketConnected = Notification.Name("SOCKET_CONNECTED")
    static let socketDisconnected = Notification.Name("SOCKET_DISCONNECTED")
    static let socketJoined = Notification.Name("SOCKET_JOINED")
    static let socketNewMessageStatus = Notification.Name("SOCKET_NEW_MESSAGE_STATUS")
    static let socketNewMessage = Notification.Name("SOCKET_NEW_MESSAGE")
    static let socketContactPaired = Notification.Name("SOCKET_CONTACT_PAIRED")
    static let socketBroadcastStatus = Notification.Name("SOCKET_BROADCAST_STATUS")
    static let socketOnlineStatus = Notification.Name("SOCKET_ONLINE_STATUS")
    
    static let unauthorizeUser = Notification.Name("UNAUTHORIZE_USER")
    static let chatTabBadge = Notification.Name("CHAT_TAB_BADGE")
}
