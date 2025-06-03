//
//  ChattingViewModel.swift
//  Cure
//
//  Created by MacBook Air MII  on 19/5/25.
//

import Foundation


struct ChattingListItemViewModel: Equatable, Identifiable {
    var id: String
    
    let messageContent: String
    let messageTime: String
    let messageDayDate: String
    
    let status: DeliveryStatus
    
    static let formatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        return formatter
    }()
}

extension ChattingListItemViewModel {
    init(message: ChatMessage) {
        id = message.id
        messageContent = message.base?.content ?? ""
        if let date = Self.formatter.date(from: message.base?.timestamp ?? "") {
            messageTime = Self.formatter.string(from: date)
        } else {
            messageTime = ""
        }

        messageDayDate = String(messageTime.split(separator: "T").first ?? "")
        status = DeliveryStatus(rawValue: message.base?.status ?? "") ?? .sent
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter
}()
