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
        query: ChatContactQuery,
        page: Int,
        size: Int,
        cached: @escaping (ChatContactsPageDTO) -> Void,
        completion: @escaping (Result<ChatContactsPage, Error>) -> Void
    ) -> Cancellable?
}
