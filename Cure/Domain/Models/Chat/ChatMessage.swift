//
//  ChatMessage.swift
//  Cure
//
//  Created by MacBook Air MII  on 19/5/25.
//

import Foundation

struct ChatMessage: Equatable, Identifiable, Codable {
    static func == (lhs: ChatMessage, rhs: ChatMessage) -> Bool {
        return (lhs.id == rhs.id)
    }
    
    typealias Identifier = String
    
    var id: Identifier {
        return "\(base.messageLogID)"
    }
    
    let reply: MessageReply?
    let detail: MessageDetail
    let base: BaseMessage
}

struct BaseMessage: Codable {
    let companyHuntingNumberID: Int
    let content, status, timestamp: String
    let readAt: String?
    let channelID: Int
    let type, companyHuntingNumber: String
    let messageLogID, roomID: Int
    let deliveredAt: String?
    let format: String
    let errorLog: String?
    let whatsapp: String?
    let contactNumber: String
    let media, instagram: String?
    let contactID: Int
    let employeeID: Int?
    
    enum CodingKeys: String, CodingKey {
        case companyHuntingNumberID, content, status, timestamp, readAt, channelID, type, companyHuntingNumber, messageLogID
        case roomID = "roomId"
        case deliveredAt, format, errorLog, whatsapp, contactNumber, media, instagram, contactID, employeeID
    }
}

// MARK: - Detail
struct MessageDetail: Codable {
    let location, referral: String?
    let whatsappMessageLogID: Int
    let isForwarded: Bool
    let messageLogID: Int
    let replyMessageID: Int
    let template: String?
    let waMessageID: String
}

// MARK: - Employee
struct MessageEmployee: Codable {
    let id: Int
    let name: String
    let photourl: String?
}

// MARK: - Reply
struct MessageReply: Codable {
    let content: String
    let messagelogid: Int
    let format: String
}

struct ChatMessagesPage: Codable {
    let page: Int
    let size: Int
    let totalPages: Int
    let chatMessages: [ChatMessage]
}
