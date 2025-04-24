//
//  ChatContactsResponseEntity+Mapping.swift
//  Cure
//
//  Created by MacBook Air MII  on 24/4/25.
//

import Foundation
import CoreData

// Individual Contact Data
extension ChatContactResponseEntity {
    func toDTO() -> ChatContactResponseDTO {
        return .init(
            
        )
    }
}

// Essentially contact data wrapped inside of baseResponse
/// Base response should contain be cotai pagination information of the chatContact data list
extension ChatContactsResponseEntity {
    func toDTO() ->  {
        return .init(
            
        )
    }
}


