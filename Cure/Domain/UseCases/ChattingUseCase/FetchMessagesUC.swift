//
//  FetchMessageUC.swift
//  Cure
//
//  Created by MacBook Air MII  on 19/5/25.
//

protocol FetchMessagesUseCase {
    func execute(
        requestValue: FetchMessagesUseCaseRequestValue,
        cached: @escaping (MessagesPageDTO) -> Void,
        completion: @escaping (Result<ChatMessagesPage, Error>) -> Void
    ) -> Cancellable?
}

final class DefaultFetchMessagesUseCase: FetchMessagesUseCase {
    private let fetchMessageRepository: IChattingRepository
    private let messagesQueryRepository: IChattingQueriesRepository
    
    init(
        fetchMessageRepository: IChattingRepository,
        messagesQueryRepository: IChattingQueriesRepository
    ) {
        self.fetchMessageRepository = fetchMessageRepository
        self.messagesQueryRepository = messagesQueryRepository
    }
    
    func execute(
        requestValue: FetchMessagesUseCaseRequestValue,
        cached: @escaping (MessagesPageDTO) -> Void,
        completion: @escaping (Result<ChatMessagesPage, any Error>) -> Void
    ) -> (any Cancellable)? {
        return fetchMessageRepository.fetchMessages(
            messageChannel: requestValue.messageChannel,
            query: requestValue.query,
            companyHuntingNumberId: requestValue.companyHuntingNumberId,
            contactId: requestValue.contactId,
            contactPairingId: requestValue.contactPairingId,
            page: requestValue.page,
            cached: cached,
            completion: { result in
                switch result {
                case .success(let page):
//                    print("Message Page in Execute: ", page)
                    completion(.success(page.toDomain()))
                case .failure(let error):
                    completion(.failure(error))
                }
                
            }
        )
    }
}



struct FetchMessagesUseCaseRequestValue {
    let messageChannel: String
    let query: ChattingQuery
    let companyHuntingNumberId: Int
    let contactId: Int
    let contactPairingId: Int
    let page: Int
}
