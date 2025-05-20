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
    func toDTO() -> MessageResponseDTO {
        return .init(
            contactPairingID: <#T##Int#>,
            contactID: <#T##Int#>,
            contactName: <#T##String?#>,
            isActive: <#T##Bool#>,
            contactNumber: <#T##String?#>,
            photoURL: <#T##String?#>)
    }
}

// Essentially contact data wrapped inside of coredata baseResponse
/// Coredata Base response should contain pagination information of the chatContact data list
extension ChattingsResponseEntity {
    func toDTO() -> MessagesPageDTO {
        return MessagesPageDTO(
            filter: filter ?? "all",
            timeStamp: timeStamp ?? Date(),
            page: Int(page),
            size: Int(size),
            totalPages: Int(totalPages),
            chatMessages: (messages?.allObjects as? [ChattingResponseEntity])?.map { $0.toDTO() } ?? []
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

extension MessageResponseDTO {
    func toEntity(in context: NSManagedObjectContext) -> ChattingResponseEntity {
        let entity: ChattingResponseEntity = .init(context: context)
        entity.channelID = Int32(contactID)
        entity.channelName = contactName
        
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
