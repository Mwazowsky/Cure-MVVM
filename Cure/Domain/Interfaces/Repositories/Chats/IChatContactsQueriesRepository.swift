//
//  IChatContactsQueriesRepository.swift
//  Cure
//
//  Created by MacBook Air MII  on 24/4/25.
//

import Foundation

protocol IChatContactsQueriesRepository {
    func fetchRecentsQueries(
        maxCount: Int,
        completion: @escaping (Result<[ChatContactQuery], Error>) -> Void
    )
    
    func saveRecentQuery(
        query: ChatContactQuery,
        completion: @escaping (Result<ChatContactQuery, Error>) -> Void
    )
}
