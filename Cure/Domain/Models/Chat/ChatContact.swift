//
//  Chat.swift
//  Cure
//
//  Created by MacBook Air MII  on 24/4/25.
//

import Foundation

struct ChatContact: Equatable, Identifiable {
    typealias Identifier = String
    
    let id: Identifier
    let contactName: String
}

struct ChatContactsPage: Equatable {
    let page: Int
    let totalPage: Int
    let chatContacts: [ChatContact]
}
