//
//  ChatContactResponseDTO+Mapping.swift
//  Cure
//
//  Created by MacBook Air MII  on 14/4/25.
//

import Foundation

// Move this later
enum RoomStatus: String, Codable {
    case all = "all"
    case ongoing = "ongoing"
    case resolved = "resolved"
    case unresolved = "unresolved"
    case newexpired = "new"
}

// Move this later
enum StatusChat: String, Codable {
    case read
    case delivered
    case failed
    case sent
}

enum ChannelType {
    case whatsapp
    case instagram
    case none
}

struct ChatContact: Codable {
    let contactPairingID: Int
    let contactID: Int
    let contactName: String?
    let isActive: Bool
    let contactNumber: String? // -
    let photoURL: String?
    let companyHuntingNumberID: Int
    let companyHuntingNumberName: String
    let companyHuntingNumberPhone: String? // -
    let companyID: Int
    let companyName: String
    let totalUnread: Int
    let lastRoomStatus: RoomStatus?
    let lastMessage: LastMessage?
    let isBlocked: Bool
    let isNew: Bool
    
    // update instagram struct
    let channelID: Int?
    let channelName: String?
    let instagram: ChatContactInstagram?
    let whatsapp: ChatContactWhatsapp?
    
    @OptionallyDecodable var lastFreeformStatus: Bool?

    enum CodingKeys: String, CodingKey {
        case contactPairingID, contactID, contactName, isActive, contactNumber
        case photoURL
        case companyHuntingNumberID, companyHuntingNumberName, companyHuntingNumberPhone, companyID, companyName, totalUnread, lastRoomStatus, lastMessage, lastFreeformStatus
        case isBlocked
        case isNew
        case instagram
        case whatsapp
        case channelID
        case channelName
    }
    
    func isFrom() -> ChannelType {
        switch self.channelID {
        case 1:
            return .whatsapp
        case 2:
            return .instagram
        default:
            return .none
        }
    }
    
    func getPhoneId() -> String {
        let whatsapp = self.whatsapp
        let instagram = self.instagram
        let isFrom = isFrom()
        
        switch isFrom {
        case .whatsapp:
            return whatsapp?.companyHuntingPhoneId ?? ""
        case .instagram:
            return instagram?.companyHuntingInstagramSenderId ?? ""
        default:
            return ""
        }
    }
}

// MARK: - LastMessage
struct LastMessage: Codable {
    let messageLogID: Int
    let waMessageID, messageMetaID: String?
    let timestamp, content, status: String
    let type: String
}

struct ChatNotifStatus: Codable {
    let id: String
    let status: StatusChat
    let timestamp: String
}

struct ChatContactWhatsapp: Codable {
    var companyHuntingPhoneId: String
    var companyHuntingWabaId: String
    var contactNumber: String
    var companyHuntingNumber: String
    
}

struct ChatContactInstagram: Codable {
    var companyHuntingInstagramId: String
    var companyHuntingUsername: String
    var companyHuntingInstagramSenderId: String?
    var contactInstagramId: String
    var contactUsername: String
    
}

extension ChatContact {
    func with(totalUnread: Int) -> ChatContact {
        return ChatContact(
            contactPairingID: self.contactPairingID,
            contactID: self.contactID,
            contactName: self.contactName,
            isActive: self.isActive,
            contactNumber: self.contactNumber,
            photoURL: self.photoURL,
            companyHuntingNumberID: self.companyHuntingNumberID,
            companyHuntingNumberName: self.companyHuntingNumberName,
            companyHuntingNumberPhone: self.companyHuntingNumberPhone,
            companyID: self.companyID,
            companyName: self.companyName,
            totalUnread: totalUnread,
            lastRoomStatus: self.lastRoomStatus,
            lastMessage: self.lastMessage,
            isBlocked: self.isBlocked,
            isNew: self.isNew,
            channelID: self.channelID,
            channelName: self.channelName,
            instagram: self.instagram,
            whatsapp: self.whatsapp,
            lastFreeformStatus: self.lastFreeformStatus
        )
    }
}

