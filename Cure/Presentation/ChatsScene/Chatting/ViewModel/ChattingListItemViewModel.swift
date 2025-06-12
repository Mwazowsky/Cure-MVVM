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
    let direction: MessageDirection
    let contentFormat: MessageContentFormat
    let recievedAt: String
    let status: DeliveryStatus
    
    let employeeName: String?
    let employeeId: Int?
    let employeePhoto: String?
    
    static let formatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        return formatter
    }()
}

// MARK: - Time Indicator
extension ChattingListItemViewModel {
    init(message: ChatMessage) {
        id = message.id
        
        var timeString: String = ""
        if let timeStampString = message.base?.timestamp,
           let date = ChatContactsListItemViewModel.formatter.date(from: timeStampString) {
            timeString  = date.stringHour24()
        }
        
        messageContent = message.base?.content ?? ""
        if let date = Self.formatter.date(from: message.base?.timestamp ?? "") {
            messageTime = Self.formatter.string(from: date)
        } else {
            messageTime = ""
        }

        recievedAt = timeString
        messageDayDate = String(messageTime.split(separator: "T").first ?? "")
        direction = message.direction
        contentFormat = message.contentFormat
        status = DeliveryStatus(rawValue: message.base?.status ?? "") ?? .sent
        
        employeeName = message.employee?.name
        employeeId = message.employee?.id
        employeePhoto = message.employee?.photourl
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter
}()
