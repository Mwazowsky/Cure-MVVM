//
//  ChattingRequestDTO+Mapping.swift
//  Cure
//
//  Created by MacBook Air MII  on 19/5/25.
//

import Foundation

struct MessagesPageDTO: Codable {
    let filter: String
    let timeStamp: Date
    let page: Int
    let size: Int
    let totalPages: Int
    let chatMessages: [MessageResponseDTO]
}

struct MessageResponseDTO: Codable {
    let contactPairingID: Int
    let contactID: Int
    let contactName: String?
    let isActive: Bool
    let contactNumber: String?
    let photoURL: String?
    
    enum CodingKeys: String, CodingKey {
        case contactPairingID,
             contactID,
             contactName,
             isActive,
             contactNumber
        case photoURL
    }
}


extension MessagesPageDTO {
    func toDomain() -> ChatMessagesPage {
        return ChatMessagesPage(
            page: page,
            size: size,
            totalPages: totalPages,
            chatMessages: chatMessages.map { $0.toDomain() }
        )
    }
}

extension MessageResponseDTO {
    func toDomain() -> ChatMessage {
        return .init(
            reply: <#T##MessageReply?#>,
            detail: <#T##MessageDetail#>,
            base: <#T##BaseMessage#>
        )
    }
}
