//
//  IChattingRepository.swift
//  Cure
//
//  Created by MacBook Air MII  on 19/5/25.
//

protocol IChattingRepository {
    @discardableResult
    func fetchMessages(
        messageChannel: String,
        query: ChattingQuery,
        companyHuntingNumberId: Int,
        contactId: Int,
        contactPairingId: Int,
        page: Int,
        cached: @escaping (MessagesPageDTO) -> Void,
        completion: @escaping (Result<MessagesPageDTO, Error>) -> Void
    ) -> Cancellable?
}
