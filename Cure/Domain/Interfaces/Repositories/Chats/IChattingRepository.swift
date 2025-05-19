//
//  IChattingRepository.swift
//  Cure
//
//  Created by MacBook Air MII  on 19/5/25.
//

protocol IChattingRepository {
    @discardableResult
    func fetchMessages(
        query: ChattingQuery,
        page: Int,
        size: Int,
        cached: @escaping (ChatMessagesPage) -> Void,
        completion: @escaping (Result<ChatMessagesPage, Error>) -> Void
    ) -> Cancellable?
}
