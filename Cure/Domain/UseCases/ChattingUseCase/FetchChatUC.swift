//
//  FetchChatUC.swift
//  Cure
//
//  Created by MacBook Air MII  on 23/4/25.
//

protocol FetchChatContactsUseCase {
    func execute(
        cached: @escaping (ChatContactsPage) -> Void,
        completion: @escaping (Result<ChatContactsPage, Error>) -> Void
    ) -> Cancellable?
}

final class DefaultFetchChatContactsUseCase: FetchChatContactsUseCase {
    private let chatContactsRepository: IChatContactsRepository
    private let chatsContactsQueriesRepository: IChatContactsQueriesRepository
    
    init(
        chatContactsRepository: IChatContactsRepository,
        chatsContactsQueriesRepository: IChatContactsQueriesRepository
    ) {
        self.chatContactsRepository = chatContactsRepository
        self.chatsContactsQueriesRepository = chatsContactsQueriesRepository
    }
    
    func execute(
        cached: @escaping (ChatContactsPage) -> Void,
        completion: @escaping (Result<ChatContactsPage, any Error>) -> Void
    ) -> (any Cancellable)? {
        
        return chatContactsRepository.fetchChatContactsList(
            cached: cached,
            completion: { result in
                if case .success = result {
                    print("Result Chat Contact Fetching", result)
                }
                
            }
        )
    }
}

struct FetchChatUseCaseRequestValue {
    let query: ChatContactQuery?
    let page: Int
}
