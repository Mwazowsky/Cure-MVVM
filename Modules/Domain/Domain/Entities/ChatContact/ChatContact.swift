//
//  ChatContact.swift
//  Domain
//
//  Created by MacBook Air MII  on 28/5/25.
//

import Foundation

struct ChatContact: Equatable, Identifiable, Codable {
    typealias Identifier = String
    
    // MARK: - ID
    var id: Identifier {
        return "\(contactID)"
    }

    // MARK: - Core Info
    let contactPairingID: Int
    let contactID: Int
    let contactName: String?
    let isActive: Bool
    let contactNumber: String?
    let photoURL: String?

    // MARK: - Company Info
    let companyHuntingNumberID: Int
    let companyHuntingNumberName: String
    let companyHuntingNumberPhone: String?
    let companyID: Int
    let companyName: String

    // MARK: - Status Info
    let totalUnread: Int
    let lastRoomStatus: RoomStatus?
    let lastMessage: LastMessage?
    let isBlocked: Bool
    let isNew: Bool
    let lastFreeformStatus: Bool?

    // MARK: - Channel Info
    let channelID: Int?
    let channelName: String?

    // MARK: - Socials
    let instagram: ChatContactInstagram?
    let whatsapp: ChatContactWhatsapp?
}

extension ChatContact {
    init(from dto: ChatContactResponseDTO) {
        self.contactPairingID = dto.contactPairingID
        self.contactID = dto.contactID
        self.contactName = dto.contactName
        self.isActive = dto.isActive
        self.contactNumber = dto.contactNumber
        self.photoURL = dto.photoURL
        self.companyHuntingNumberID = dto.companyHuntingNumberID
        self.companyHuntingNumberName = dto.companyHuntingNumberName
        self.companyHuntingNumberPhone = dto.companyHuntingNumberPhone
        self.companyID = dto.companyID
        self.companyName = dto.companyName
        self.totalUnread = dto.totalUnread
        self.lastRoomStatus = dto.lastRoomStatus
        self.lastMessage = dto.lastMessage
        self.isBlocked = dto.isBlocked
        self.isNew = dto.isNew
        self.channelID = dto.channelID
        self.channelName = dto.channelName
        self.instagram = dto.instagram
        self.whatsapp = dto.whatsapp
        self.lastFreeformStatus = dto.lastFreeformStatus
    }
}

struct ChatContactResponseDTO: Codable {
    let contactPairingID: Int
    let contactID: Int
    let contactName: String?
    let isActive: Bool
    let contactNumber: String?
    let photoURL: String?
    let companyHuntingNumberID: Int
    let companyHuntingNumberName: String
    let companyHuntingNumberPhone: String?
    let companyID: Int
    let companyName: String
    let totalUnread: Int
    let lastRoomStatus: RoomStatus?
    let lastMessage: LastMessage?
    let isBlocked: Bool
    let isNew: Bool
    
    let channelID: Int?
    let channelName: String?
    let instagram: ChatContactInstagram?
    let whatsapp: ChatContactWhatsapp?
    
    var lastFreeformStatus: Bool?

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

extension ChatContactResponseDTO {
    func with(totalUnread: Int) -> ChatContactResponseDTO {
        return ChatContactResponseDTO(
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

struct ChatContactsPage: Codable {
    let page: Int
    let size: Int
    let chatContacts: [ChatContact]
}


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

// MARK: - LastMessage
struct LastMessage: Equatable, Codable {
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

struct ChatContactWhatsapp: Equatable, Codable {
    var companyHuntingPhoneId: String
    var companyHuntingWabaId: String
    var contactNumber: String
    var companyHuntingNumber: String
    
}

struct ChatContactInstagram: Equatable, Codable {
    var companyHuntingInstagramId: String
    var companyHuntingUsername: String
    var companyHuntingInstagramSenderId: String?
    var contactInstagramId: String
    var contactUsername: String
    
}
