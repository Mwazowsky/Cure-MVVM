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
    func toDTO() -> MessageDTO {
        let replyDTO: MessageReplyDTO? = self.reply?.toDTO()
        let detailDTO: MessageDetailDTO? = self.detail?.toDTO()
        let baseDTO: BaseMessageDTO? = self.base?.toDTO()

        return MessageDTO(
            reply: replyDTO,
            detail: detailDTO,
            base: baseDTO
        )
    }
}


// Essentially contact data wrapped inside of coredata baseResponse
/// Coredata Base response should contain pagination information of the chatContact data list
extension ChattingsResponseEntity {
    func toDTO() -> MessagesPageDTO {
        let chatEntities = (messages?.allObjects as? [ChattingResponseEntity]) ?? []
        
        let messageDTOs: [MessageDTO] = chatEntities.map { $0.toDTO() }
        let messagesDTO = MessagesDTO(messages: messageDTOs, page: Int(page), total: Int(totalPages))

        return MessagesPageDTO(
            filter: filter ?? "all",
            timeStamp: timeStamp ?? Date(),
            page: Int(page),
            size: Int(size),
            chatMessages: messagesDTO
        )
    }
}


extension ChattingRequestDTO {
    func toEntity(in context: NSManagedObjectContext) -> ChattingsRequestEntity {
        let entity: ChattingsRequestEntity = .init(context: context)
        entity.filter = filter
        entity.page = Int16(page)
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
