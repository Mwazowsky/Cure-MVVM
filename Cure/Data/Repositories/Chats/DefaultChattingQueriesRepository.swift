//
//  DefaultChattingQueriesRepository.swift
//  Cure
//
//  Created by MacBook Air MII  on 19/5/25.
//

import Foundation

final class DefaultChattingQueriesRepository {
    private var chattingQueriesPersistentStorage: ChattingQueriesStorage
    
    init(chattingQueriesPersistentStorage: ChattingQueriesStorage) {
        self.chattingQueriesPersistentStorage = chattingQueriesPersistentStorage
    }
}


extension DefaultChattingQueriesRepository: IChattingQueriesRepository {
    func fetchRecentQueries(
        maxCount: Int,
        completion: @escaping (Result<[ChattingQuery], any Error>) -> Void
    ) {
        return chattingQueriesPersistentStorage.fetchRecentsQueries(
            maxCount: maxCount,
            completion: completion
        )
    }
    
    func saveRecentQuery(
        query: ChattingQuery,
        completion: @escaping (Result<ChattingQuery, any Error>) -> Void
    ) {
        chattingQueriesPersistentStorage.saveRecentQuery(
            query: query,
            completion: completion
        )
    }
}
