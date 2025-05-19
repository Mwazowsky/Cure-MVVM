//
//  ChattingRequestDTO+Mapping.swift
//  Cure
//
//  Created by MacBook Air MII  on 19/5/25.
//

import Foundation

struct ChattingRequestDTO: Encodable {
    let filter: String
    let page: Int
    let size: Int
}
