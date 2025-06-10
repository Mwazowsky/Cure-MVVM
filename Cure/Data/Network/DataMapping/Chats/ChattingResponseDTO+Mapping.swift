//
//  ChattingRequestDTO+Mapping.swift
//  Cure
//
//  Created by MacBook Air MII  on 19/5/25.
//

import Foundation
import CoreData

struct MessagesPageDTO: Codable {
    let filter: String
    let timeStamp: Date
    let page: Int
    let size: Int
    let chatMessages: MessagesDTO
}

struct MessagesDTO: Codable {
    let messages: [MessageDTO]
    let page: Int
    let total: Int
}

struct MessageDTO: Codable {
    let reply: MessageReplyDTO?
    let detail: MessageDetailDTO?
    let base: BaseMessageDTO?
}

// MARK: - Reply DTO
struct MessageReplyDTO: Codable {
    let content: String
    let messageLogID: Int
    let format: String
}

// MARK: - Detail DTO
struct MessageDetailDTO: Codable {
//    let location: String?
    let referral: String?
    let whatsappMessageLogID: Int
    let isForwarded: Bool
    let messageLogID: Int
    let replyMessageID: String?
//    let template: String?
    let waMessageID: String
}

// MARK: - Base DTO
struct BaseMessageDTO: Codable {
    let messageLogID: Int
    let channelID: Int
    let waMessageID: String?
    let companyHuntingNumberID: Int
    let contactID: Int
    let employeeID: Int?
    let companyHuntingNumber: String
    let contactNumber: String
    let content: String
    let type: String
    let status: String
    let format: String
    let readLog: String?
    let errorLog: String?
    let roomID: Int?
    let timestamp: String
    let deliveredAt: String?
    let readAt: String?
//    let media: String?
    
    enum CodingKeys: String, CodingKey {
        case roomID = "roomId"
        case messageLogID
        case channelID
        case waMessageID
        case companyHuntingNumberID
        case contactID
        case employeeID
        case companyHuntingNumber
        case contactNumber
        case content
        case type
        case status
        case format
        case readLog
        case errorLog
        case timestamp
        case deliveredAt
        case readAt
//        case media
    }
}


extension MessagesPageDTO {
    func toDomain() -> ChatMessagesPage {
        return ChatMessagesPage(
            filter: filter,
            timeStamp: timeStamp,
            page: page,
            size: size,
            chatMessages: chatMessages.toDomain().messages
        )
    }
}

/// Transform individual message from MessagesDTO into ChatMessage
/// data: { MessagesPageDTO
///     ..., other properties
///     messages: [ MessagesDTO
///         { MessageDTO (This)
///             reply:
///             detail:
///             base:
///         }
///     ]
/// }
///
/// Into
/// data: { MessagesPageDTO
///     messages: [ MessagesDTO
///         { ChatMessage(This)
///             reply:
///             detail:
///             base:
///         }
///     ]
/// }
extension MessageDTO {
    func toDomain() -> ChatMessage {
        return .init(
            reply: reply?.toDomainModel(),
            detail: detail?.toDomainModel(),
            base: base?.toDomainModel())
    }
}

/// Transform array of messages from MessagesPageDTO into ChatMessages
/// data: { MessagesPageDTO
///     ..., other properties
///     messages: [ ChatMessages (THIS)
///         { MessageDTO
///             reply:
///             detail:
///             base:
///         }
///     ]
/// }
///
/// Into
/// data: { MessagesPageDTO
///     messages: [ ChatMessages (THIS)
///         { ChatMessage
///             reply:
///             detail:
///             base:
///         }
///     ]
/// }
extension MessagesDTO {
    func toDomain() -> ChatMessages {
        return ChatMessages(
            messages: messages.toDomainModel()
        )
    }
}

// MARK: - ReplyMessageDTO
/// To Domain
extension MessageReplyDTO {
    func toDomainModel() -> MessageReply {
        MessageReply(
            content: content,
            messageLogID: messageLogID,
            format: format
        )
    }
}

/// To Entity
extension MessageReplyDTO {
    func toEntity(in context: NSManagedObjectContext) -> M_ReplyMessageEntity {
        let entity = M_ReplyMessageEntity(context: context)
        entity.content = content
        entity.messageLogID = Int16(messageLogID)
        entity.format = format
        return entity
    }
}

/// To DTO
extension M_ReplyMessageEntity {
    func toDTO() -> MessageReplyDTO {
        MessageReplyDTO(
            content: content ?? "",
            messageLogID: Int(messageLogID),
            format: format ?? ""
        )
    }
}

// MARK: - DetailMessageDTO
/// To Domain
extension MessageDetailDTO {
    func toDomainModel() -> MessageDetail {
        MessageDetail(
//            location: location,
            referral: referral,
            whatsappMessageLogID: whatsappMessageLogID,
            isForwarded: isForwarded,
            messageLogID: messageLogID,
            replyMessageID: replyMessageID,
//            template: template,
            waMessageID: waMessageID
        )
    }
}

/// To Entity
extension MessageDetailDTO {
    func toEntity(in context: NSManagedObjectContext) -> M_DetailMessageEntity {
        let entity = M_DetailMessageEntity(context: context)
//        entity.location = location
        entity.referral = referral
        entity.whatsappMessageLogID = Int16(whatsappMessageLogID)
        entity.isForwarded = isForwarded
        entity.messageLogID = Int16(messageLogID)
        entity.replyMessageID = replyMessageID ?? ""
//        entity.template = template
        entity.waMessageID = waMessageID
        return entity
    }
}

/// To DTO
extension M_DetailMessageEntity {
    func toDTO() -> MessageDetailDTO {
        MessageDetailDTO(
//            location: location,
            referral: referral,
            whatsappMessageLogID: Int(whatsappMessageLogID),
            isForwarded: isForwarded,
            messageLogID: Int(messageLogID),
            replyMessageID: replyMessageID,
//            template: template,
            waMessageID: waMessageID ?? ""
        )
    }
}


// MARK: - BaseMessageDTO
/// To Domain
extension BaseMessageDTO {
    func toDomainModel() -> BaseMessage {
        return BaseMessage(
            messageLogID: self.messageLogID,
            channelID: self.channelID,
            waMessageID: self.waMessageID,
            companyHuntingNumberID: self.companyHuntingNumberID,
            contactID: self.contactID,
            employeeID: self.employeeID,
            companyHuntingNumber: self.companyHuntingNumber,
            contactNumber: self.contactNumber,
            content: self.content,
            type: self.type,
            status: self.status,
            format: self.format,
            readLog: self.readLog,
            errorLog: self.errorLog,
            roomID: self.roomID,
            timestamp: self.timestamp,
            deliveredAt: self.deliveredAt,
            readAt: self.readAt
//            media: self.media
        )
    }
}


/// To Entity
extension BaseMessageDTO {
    func toEntity(in context: NSManagedObjectContext) -> M_BaseMessageEntity {
        let entity = M_BaseMessageEntity(context: context)
        entity.messageLogID = Int16(messageLogID)
        entity.channelID = Int16(channelID)
        entity.waMessageID = waMessageID
        entity.companyHuntingNumberID = Int16(companyHuntingNumberID)
        entity.contactID = Int16(contactID)
        entity.employeeID = Int16(employeeID ?? 0)
        entity.companyHuntingNumber = companyHuntingNumber
        entity.contactNumber = contactNumber
        entity.content = content
        entity.type = type
        entity.status = status
        entity.format = format
        entity.readLog = readLog
        entity.errorLog = errorLog
        entity.roomID = Int16(roomID ?? 0)
        entity.timestamp = timestamp
        entity.deliveredAt = deliveredAt
        entity.readAt = readAt
//        entity.media = media
        return entity
    }
}

/// To DTO
extension M_BaseMessageEntity {
    func toDTO() -> BaseMessageDTO {
        BaseMessageDTO(
            messageLogID: Int(messageLogID),
            channelID: Int(channelID),
            waMessageID: waMessageID,
            companyHuntingNumberID: Int(companyHuntingNumberID),
            contactID: Int(contactID),
            employeeID: Int(employeeID),
            companyHuntingNumber: companyHuntingNumber ?? "",
            contactNumber: contactNumber ?? "",
            content: content ?? "",
            type: type ?? "",
            status: status ?? "",
            format: format ?? "",
            readLog: readLog,
            errorLog: errorLog,
            roomID: Int(roomID),
            timestamp: timestamp ?? "",
            deliveredAt: deliveredAt,
            readAt: readAt
//            media: media
        )
    }
}


extension Array where Element == MessageDTO {
    func toDomainModel() -> [ChatMessage] {
        return self.map { $0.toDomain() }
    }
}
