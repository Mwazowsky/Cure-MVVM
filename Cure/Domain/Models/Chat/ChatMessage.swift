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
        return "\(base?.messageLogID ?? 0)"
    }
    
    let reply: MessageReply?
    let detail: MessageDetail?
    let base: BaseMessage?
}

struct ChatData: Equatable, Identifiable, Codable {
    static func == (lhs: ChatData, rhs: ChatData) -> Bool {
        return (lhs.id == rhs.id)
    }
    
    typealias Identifier = String
    
    var id: Identifier
    
    let data: [ChatMessages]
}

struct ChatMessages: Codable {
    let messages: [ChatMessage]
}

struct BaseMessage: Codable {
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
    let roomID: Int
    let timestamp: String
    let deliveredAt: String?
    let readAt: String?
    let media: String?
    
    enum CodingKeys: String, CodingKey {
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
        case roomID = "roomId"
        case timestamp
        case deliveredAt
        case readAt
        case media
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
    let messageLogID: Int
    let format: String
}

struct ChatMessagesPage: Codable {
    let filter: String
    let timeStamp: Date
    let page: Int
    let size: Int
    let totalPages: Int
//    let chatMessages: [ChatMessage]
}
