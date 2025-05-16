//
//  ChatContactsListItemViewModel.swift
//  Cure
//
//  Created by MacBook Air MII  on 2/5/25.
//

// **Note**: This item view model is to display data and does not contain any domain model to prevent views accessing it

import Foundation

struct ChatContactsListItemViewModel: Equatable, Identifiable {
    var id: String
    
    let contactName: String
    let lastMessage: String
    let dayOrTime: String
    let profileImage: String?
    
    let channelIdUrl: String
    let company: String
    
    static let formatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        return formatter
    }()
}

extension ChatContactsListItemViewModel {
    init(chatContact: ChatContact) {
        self.id = chatContact.id
        self.contactName = chatContact.contactName ?? ""
        self.profileImage = chatContact.photoURL
        self.lastMessage = chatContact.lastMessage?.content ?? ""
        
        var timeString: String = ""
        var channelIdImageUrl: String = ""
        
        if let timeStampString = chatContact.lastMessage?.timestamp,
            let date = ChatContactsListItemViewModel.formatter.date(from: timeStampString) {
            
            let isSameDay = date.isToday
            let isSameWeek = date.isThisWeek
            
            if isSameDay() {
                timeString  = date.stringHour24()
            } else if isSameWeek() {
                timeString = date.stringDay()
            } else {
                timeString = date.stringDateDMY()
            }
        }
        
        self.dayOrTime = timeString
        
        if let channelId = chatContact.channelID {
            if channelId == 1 {
                channelIdImageUrl  = "whatsapp"
            } else if channelId == 2 {
                channelIdImageUrl = "instagram"
            } else {
                channelIdImageUrl  = "whatsapp"
            }
        }
        
        self.channelIdUrl = channelIdImageUrl
        self.company = chatContact.companyName
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter
}()
