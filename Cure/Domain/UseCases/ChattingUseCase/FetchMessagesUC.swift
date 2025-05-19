//
//  FetchMessageUC.swift
//  Cure
//
//  Created by MacBook Air MII  on 19/5/25.
//

protocol FetchMessagesUseCase {
    func execute(
        requestValue: FetchMessagesUseCaseRequestValue,
        cached: @escaping (ChatMessagesPage) -> Void,
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
        cached: @escaping (ChatMessagesPage) -> Void,
        completion: @escaping (Result<ChatMessagesPage, any Error>) -> Void
    ) -> (any Cancellable)? {
        return fetchMessageRepository.fetchMessages(
            query: requestValue.query,
            page: requestValue.page,
            size: requestValue.size,
            cached: cached,
            completion: { result in
                switch result {
                case .success(let page):
                    completion(.success(page))
                case .failure(let error):
                    completion(.failure(error))
                }
                
            }
        )
    }
}



struct FetchMessagesUseCaseRequestValue {
    let query: ChattingQuery
    let page: Int
    let size: Int
}
