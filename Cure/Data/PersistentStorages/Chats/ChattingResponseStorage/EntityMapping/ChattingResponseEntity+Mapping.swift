//
//  ChatContactsResponseEntity+Mapping.swift
//  Cure
//
//  Created by MacBook Air MII  on 24/4/25.
//

import Foundation
import CoreData

// Individual Message Data
extension ChattingResponseEntity {
    func toDTO() -> ChatMessage {
        let replyDTO: MessageReplyDTO = self.reply?.toDTO() ?? MessageReplyDTO(content: "", messageLogID: 0, format: "")
        let detailDTO: MessageDetailDTO = self.detail?.toDTO() ?? MessageDetailDTO(location: "", referral: "", whatsappMessageLogID: 0, isForwarded: true, messageLogID: 0, replyMessageID: 0, template: "", waMessageID: "")
        let baseDTO: BaseMessageDTO = self.base?.toDTO() ?? BaseMessageDTO(messageLogID: 0, channelID: 0, waMessageID: "", companyHuntingNumberID: 0, contactID: 0, employeeID: 0, companyHuntingNumber: "", contactNumber: "", content: "", type: "", status: "", format: "", readLog: "", errorLog: "", roomID: 0, timestamp: "", deliveredAt: "", readAt: "", media: "")

        return ChatMessage(
            reply: replyDTO.toDomainModel(),
            detail: detailDTO.toDomainModel(),
            base: baseDTO.toDomainModel()
        )
    }
}


// Essentially contact data wrapped inside of coredata baseResponse
/// Coredata Base response should contain pagination information of the chatContact data list
extension ChattingsResponseEntity {
    func toDTO() -> MessagesPageDTO {
        let chatEntities = (messages?.allObjects as? [ChattingResponseEntity]) ?? []
        let chatMessages: [ChatMessage] = chatEntities.map { $0.toDTO() }

        return MessagesPageDTO(
            filter: filter ?? "all",
            timeStamp: timeStamp ?? Date(),
            page: Int(page),
            size: Int(size),
            totalPages: Int(totalPages),
            chatMessages: chatMessages
        )
    }
}

extension ChattingRequestDTO {
    func toEntity(in context: NSManagedObjectContext) -> ChattingsRequestEntity {
        let entity: ChattingsRequestEntity = .init(context: context)
        entity.filter = filter
        entity.page = Int16(page)
        entity.size = Int16(size)
        entity.totalPages = Int16(totalPages)
        return entity
    }
}

extension MessagesPageDTO {
    func toEntity(in context: NSManagedObjectContext) -> ChattingsResponseEntity {
        let entity: ChattingsResponseEntity = .init(context: context)
        entity.filter = filter
        entity.page = Int16(page)
        entity.size = Int16(size)
        entity.timeStamp = timeStamp
        
        return entity
    }
}
