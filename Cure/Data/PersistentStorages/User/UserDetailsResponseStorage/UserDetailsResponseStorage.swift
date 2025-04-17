//
//  UserDetailsResponseStorage.swift
//  Cure
//
//  Created by MacBook Air MII  on 16/4/25.
//

import Foundation
import CoreData

protocol UserDetailsResponseStorage {
    func getResponse(completion: @escaping (Result<UserDetailsResponse?, DataTransferError>) -> Void)
    func save(response: UserDetailsDTO)
}
