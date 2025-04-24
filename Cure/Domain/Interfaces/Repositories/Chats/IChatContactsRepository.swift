//
//  IChatContactsRepository.swift
//  Cure
//
//  Created by MacBook Air MII  on 24/4/25.
//

import Foundation

protocol IChatContactsRepository {
    @discardableResult
    func fetchChatContactsList(
        cached: @escaping (ChatContactsPage) -> Void,
        completion: @escaping (Result<ChatContactsPage, Error>) -> Void
    ) -> Cancellable?
}
