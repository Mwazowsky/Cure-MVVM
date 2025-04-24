//
//  Chat.swift
//  Cure
//
//  Created by MacBook Air MII  on 24/4/25.
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

struct ChatContactsPage: Codable {
    let page: Int
    let size: Int
    let chatContacts: [ChatContact]
}
