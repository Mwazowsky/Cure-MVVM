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

struct ChatContactsPageDTO: Codable {
    let filter: String
    let timeStamp: Date
    let page: Int
    let size: Int
    let chatContacts: [ChatContactResponseDTO]
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


extension ChatContactsPageDTO {
    func toDomain() -> ChatContactsPage {
        return ChatContactsPage(
            page: page,
            size: size,
            chatContacts: chatContacts.map { $0.toDomain() }
        )
    }
}

extension ChatContactResponseDTO {
    func toDomain() -> ChatContact {
        return .init(
            contactPairingID: contactPairingID,
            contactID: contactID,
            contactName: contactName,
            isActive: isActive,
            contactNumber: contactNumber,
            photoURL: photoURL,
            companyHuntingNumberID: companyHuntingNumberID,
            companyHuntingNumberName: companyHuntingNumberName,
            companyHuntingNumberPhone: companyHuntingNumberPhone,
            companyID: companyID,
            companyName: companyName,
            totalUnread: totalUnread,
            lastRoomStatus: lastRoomStatus,
            lastMessage: lastMessage,
            isBlocked: isBlocked,
            isNew: isNew,
            lastFreeformStatus: lastFreeformStatus,
            channelID: channelID,
            channelName: channelName,
            instagram: instagram,
            whatsapp: whatsapp)
    }
}
