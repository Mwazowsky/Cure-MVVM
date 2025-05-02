//
//  ChatContactsQueriesStorage.swift
//  Cure
//
//  Created by MacBook Air MII  on 2/5/25.
//

import Foundation

protocol ChatContactsQueriesStorage {
    func fetchRecentsQueries(
        maxCount: Int,
        completion: @escaping (Result<[ChatContactQuery], Error>) -> Void
    )
    func saveRecentQuery(
        query: ChatContactQuery,
        completion: @escaping (Result<ChatContactQuery, Error>) -> Void
    )
}
