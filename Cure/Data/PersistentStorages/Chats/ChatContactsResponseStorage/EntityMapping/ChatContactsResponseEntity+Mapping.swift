//
//  ChatContactsResponseEntity+Mapping.swift
//  Cure
//
//  Created by MacBook Air MII  on 24/4/25.
//

import Foundation
import CoreData

// Individual Contact Data
extension ChatContactResponseEntity {
    func toDTO() -> ChatContactResponseDTO {
        return .init(
            contactPairingID: Int(contactPairingID),
            contactID: Int(contactID),
            contactName: contactName,
            isActive: isActive,
            contactNumber: contactNumber,
            photoURL: photoURL,
            companyHuntingNumberID: Int(companyHuntingNumberID),
            companyHuntingNumberName: companyHuntingNumberName ?? "",
            companyHuntingNumberPhone: companyHuntingNumberPhone,
            companyID: Int(companyID),
            companyName: companyName ?? "",
            totalUnread: Int(totalUnread),
            lastRoomStatus: RoomStatus(rawValue: lastRoomStatus ?? ""),
            lastMessage: lastMessage?.toDTO(),
            isBlocked: isBlocked,
            isNew: isNew,
            channelID: Int(channelID),
            channelName: channelName ?? "",
            instagram: instagram?.toDTO(),
            whatsapp: whatsapp?.toDTO()
        )
    }
}

// Essentially contact data wrapped inside of coredata baseResponse
/// Coredata Base response should contain pagination information of the chatContact data list
extension ChatContactsResponseEntity {
    func toDTO() -> ChatContactsPageDTO {
        return ChatContactsPageDTO(
            filter: filter ?? "all",
            timeStamp: timeStamp ?? Date(),
            page: Int(page),
            size: Int(size),
            chatContacts: (chatContacts?.allObjects as? [ChatContactResponseEntity])?.map { $0.toDTO() } ?? []
        )
    }
}

// MARK: - I_...Entity Extensions
/// Instagram
extension I_ContactInstagramEntity {
    func toDTO() -> ChatContactInstagram {
        return ChatContactInstagram(
            companyHuntingInstagramId: companyHuntingInstagramId ?? "",
            companyHuntingUsername: companyHuntingUsername ?? "",
            contactInstagramId: companyHuntingInstagramId ?? "",
            contactUsername: contactUsername ?? ""
        )
    }
}

/// Whatsapp
extension I_ContactWhatsappEntity {
    func toDTO() -> ChatContactWhatsapp {
        return ChatContactWhatsapp(
            companyHuntingPhoneId: companyHuntingPhoneId ?? "",
            companyHuntingWabaId: companyHuntingWabaId ?? "",
            contactNumber: contactNumber ?? "",
            companyHuntingNumber: companyHuntingNumber ?? ""
        )
    }
}

/// LastMessage
extension I_LastMessageEntity {
    func toDTO() -> LastMessage {
        return LastMessage(
            messageLogID: Int(messageLogID),
            waMessageID: waMessageID,
            messageMetaID: messageMetaID,
            timestamp: timestamp ?? "",
            content: content ?? "",
            status: status ?? "",
            type: type ?? ""
        )
    }
}

// I_ DTO extension
/// Instagram
extension ChatContactInstagram {
    func toEntity(in context: NSManagedObjectContext) -> I_ContactInstagramEntity {
        let entity = I_ContactInstagramEntity(context: context)
        entity.companyHuntingInstagramId = companyHuntingInstagramId
        entity.companyHuntingUsername = companyHuntingUsername
        entity.contactInstagramId = contactInstagramId
        entity.contactUsername = contactUsername
        return entity
    }
}

/// Whatsapp
extension ChatContactWhatsapp {
    func toEntity(in context: NSManagedObjectContext) -> I_ContactWhatsappEntity {
        let entity = I_ContactWhatsappEntity(context: context)
        entity.companyHuntingPhoneId = companyHuntingPhoneId
        entity.companyHuntingWabaId = companyHuntingWabaId
        entity.contactNumber = contactNumber
        entity.companyHuntingNumber = companyHuntingNumber
        return entity
    }
}

/// LastMessage
extension LastMessage {
    func toEntity(in context: NSManagedObjectContext) -> I_LastMessageEntity {
        let entity = I_LastMessageEntity(context: context)
        entity.messageLogID = Int64(messageLogID)
        entity.waMessageID = waMessageID
        entity.messageMetaID = messageMetaID
        entity.timestamp = timestamp
        entity.content = content
        entity.status = status
        entity.type = type
        return entity
    }
}



extension ChatContactsRequestDTO {
    func toEntity(in context: NSManagedObjectContext) -> ChatContactsRequestEntity {
        let entity: ChatContactsRequestEntity = .init(context: context)
        entity.filter = filter
        entity.page = Int16(page)
        entity.size = Int16(size)
        return entity
    }
}

extension ChatContactResponseDTO {
    func toEntity(in context: NSManagedObjectContext) -> ChatContactResponseEntity {
        let entity: ChatContactResponseEntity = .init(context: context)
        entity.contactID = Int32(contactID)
        entity.contactName = contactName
        entity.isActive = isActive
        entity.contactNumber = contactNumber
        entity.photoURL = photoURL
        entity.companyHuntingNumberID = Int64(companyHuntingNumberID)
        entity.companyHuntingNumberName = companyHuntingNumberName
        entity.companyHuntingNumberPhone = companyHuntingNumberPhone
        entity.companyID = Int32(companyID)
        entity.companyName = companyName
        entity.totalUnread = Int32(totalUnread)
        entity.lastRoomStatus = lastRoomStatus?.rawValue
        entity.isBlocked = isBlocked
        entity.isNew = isNew
        entity.channelID = Int32(channelID ?? 0)
        entity.channelName = channelName
        entity.instagram = instagram?.toEntity(in: context)
        entity.whatsapp = whatsapp?.toEntity(in: context)
        entity.lastMessage = lastMessage?.toEntity(in: context)
        
        return entity
    }
}

extension ChatContactsPageDTO {
    func toEntity(in context: NSManagedObjectContext) -> ChatContactsResponseEntity {
        let entity: ChatContactsResponseEntity = .init(context: context)
        entity.filter = filter
        entity.page = Int16(page)
        entity.size = Int16(size)
        entity.timeStamp = timeStamp
        
        return entity
    }
}
