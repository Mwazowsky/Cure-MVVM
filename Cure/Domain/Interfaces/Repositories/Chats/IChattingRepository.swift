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
        totalPages: Int,
        cached: @escaping (MessagesPageDTO) -> Void,
        completion: @escaping (Result<MessagesPageDTO, Error>) -> Void
    ) -> Cancellable?
}
