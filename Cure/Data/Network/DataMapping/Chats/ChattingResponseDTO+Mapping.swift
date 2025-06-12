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

// MARK: - Array of Message Object
struct MessagesDTO: Codable {
    let messages: [MessageDTO]
    let page: Int
    let total: Int
}

// MARK: - Single Message Object
struct MessageDTO: Codable {
    let reply: MessageReplyDTO?
    let detail: MessageDetailDTO?
    let base: MessageBaseDTO?
    let employee: MessageEmployeeDTO?
}

// MARK: - Entity in Single Message Object
/// Base Object
struct MessageBaseDTO: Codable {
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
    let media: MediaDTO?
    
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
        case media
    }
}

/// base.media Object
struct MediaDTO: Codable {
    let messageMediaID: Int
    let messageLogID: Int
    let waMediaID: String?
    let filename: String?
    let url: String
    let mimetype: String

    enum CodingKeys: String, CodingKey {
        case messageMediaID
        case messageLogID
        case waMediaID = "waMediaId"
        case filename
        case url
        case mimetype
    }
}

/// Detail Object
struct MessageDetailDTO: Codable {
//    let location: String?
    let referral: String?
    let whatsappMessageLogID: Int
    let isForwarded: Bool
    let messageLogID: Int
    let replyMessageID: String?
//    let template: String?
    let waMessageID: String

    enum CodingKeys: String, CodingKey {
        // case location
        case referral
        case whatsappMessageLogID
        case isForwarded
        case messageLogID
        case replyMessageID
        // case template
        case waMessageID
    }
}

/// Reply Object
struct MessageReplyDTO: Codable {
    let content: String
    let messageLogID: Int
    let format: String

    enum CodingKeys: String, CodingKey {
        case content
        case messageLogID
        case format
    }
}

/// Employee Object
struct MessageEmployeeDTO: Codable {
    let id: Int?
    let name: String?
    let photoUrl: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case photoUrl
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
            base: base?.toDomainModel(),
            employee: employee?.toDomainModel()
        )
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
/// Dto To Domain
extension MessageReplyDTO {
    func toDomainModel() -> MessageReply {
        MessageReply(
            content: content,
            messageLogID: messageLogID,
            format: format
        )
    }
}

/// Dto To Entity
extension MessageReplyDTO {
    func toEntity(in context: NSManagedObjectContext) -> M_ReplyMessageEntity {
        let entity = M_ReplyMessageEntity(context: context)
        entity.content = content
        entity.messageLogID = Int16(messageLogID)
        entity.format = format
        return entity
    }
}

/// Entity To DTO
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
/// Dto To Domain
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

/// Dto To Entity
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

/// Entity To DTO
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
/// Dto To Domain
extension MessageBaseDTO {
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
            readAt: self.readAt,
            media: self.media?.toDomainModel()
        )
    }
}


/// Dto To Entity
extension MessageBaseDTO {
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
        entity.media = media?.toEntity(in: context)
        return entity
    }
}

/// Entity To DTO
extension M_BaseMessageEntity {
    func toDTO() -> MessageBaseDTO {
        MessageBaseDTO(
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
            readAt: readAt,
            media: media?.toDTO()
        )
    }
}

// MARK: - BaseMessageDTO -> MediaDTO
/// Dto To Domain
extension MediaDTO {
    func toDomainModel() -> MediaMessage {
        return MediaMessage(
            messageMediaID: self.messageMediaID,
            messageLogID: self.messageLogID,
            waMediaID: self.waMediaID,
            filename: self.filename,
            url: self.url,
            mimetype: self.mimetype
        )
    }
}

/// Dto To Entity
extension MediaDTO {
    func toEntity(in context: NSManagedObjectContext) -> M_Base_MediaEntity {
        let entity = M_Base_MediaEntity(context: context)
        entity.messageMediaID = Int32(messageMediaID)
        entity.messageLogID = Int32(messageLogID)
        entity.waMediaId = waMediaID
        entity.fileName = filename
        entity.url = url
        entity.mimetype = mimetype
        
        return entity
    }
}

/// Entity To DTO
extension M_Base_MediaEntity {
    func toDTO() -> MediaDTO {
        MediaDTO(
            messageMediaID: Int(messageMediaID),
            messageLogID: Int(messageLogID),
            waMediaID: waMediaId,
            filename: fileName,
            url: url ?? "",
            mimetype: mimetype ?? ""
        )
    }
}

// MARK: - EmployeeMessageDTO -> MediaDTO
/// Dto To Domain
extension MessageEmployeeDTO {
    func toDomainModel() -> MessageEmployee {
        return MessageEmployee(
            id: self.id,
            name: self.name,
            photourl: self.photoUrl
        )
    }
}

/// Dto To Entity
extension MessageEmployeeDTO {
    func toEntity(in context: NSManagedObjectContext) -> M_EmployeeMessageEntity {
        let entity = M_EmployeeMessageEntity(context: context)
        entity.id = Int32(id ?? 0)
        entity.name = name
        entity.photoUrl = photoUrl
        
        return entity
    }
}

/// Entity To Dto
extension M_EmployeeMessageEntity {
    func toDTO() -> MessageEmployeeDTO {
        MessageEmployeeDTO(
            id: Int(id),
            name: name,
            photoUrl: photoUrl
        )
    }
}


// MARK: Helper Extension
extension Array where Element == MessageDTO {
    func toDomainModel() -> [ChatMessage] {
        return self.map { $0.toDomain() }
    }
}
