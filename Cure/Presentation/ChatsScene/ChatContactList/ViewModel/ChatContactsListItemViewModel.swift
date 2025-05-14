//
//  ChatContactsListItemViewModel.swift
//  Cure
//
//  Created by MacBook Air MII  on 2/5/25.
//

// **Note**: This item view model is to display data and does not contain any domain model to prevent views accessing it

import Foundation

struct ChatContactsListItemViewModel: Equatable {
    let contactName: String
    let lastMessage: String
    let dateTime: String
    let profileImage: String?
}

extension ChatContactsListItemViewModel {

    init(chatContact: ChatContact) {
        self.contactName = chatContact.contactName ?? ""
        self.profileImage = chatContact.photoURL
        self.lastMessage = chatContact.lastMessage?.content ?? ""
        if let chatDateTime = chatContact.lastMessage?.timestamp {
            // DebugPoint 4 - Find out what best way in term of architectural design
            /// to parse a date time in this app
            /// Raw \(chatDateTime) timestamp string
            self.dateTime = "\(NSLocalizedString("Last Chat", comment: "")): \(chatDateTime))"
        } else {
            self.dateTime = NSLocalizedString("-", comment: "")
        }
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter
}()
