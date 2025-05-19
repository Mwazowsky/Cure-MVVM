//
//  IChattingQueriesRepository.swift
//  Cure
//
//  Created by MacBook Air MII  on 19/5/25.
//

protocol IChattingQueriesRepository {
    func fetchRecentQueries(
        maxCount: Int,
        completion: @escaping (Result<[ChattingQuery], Error>) -> Void
    )
    
    func saveRecentQuery(
        query: ChattingQuery,
        completion: @escaping (Result<ChattingQuery, Error>) -> Void
    )
}
