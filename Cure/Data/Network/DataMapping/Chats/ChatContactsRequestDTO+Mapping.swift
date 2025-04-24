//
//  ChatRequestDTO+Mapping.swift
//  Cure
//
//  Created by MacBook Air MII  on 24/4/25.
//

import Foundation

struct ChatContactsRequestDTO: Encodable {
    let query: String
    let page: Int
}
