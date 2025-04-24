//
//  DefaultChatsRepository.swift
//  Cure
//
//  Created by MacBook Air MII  on 24/4/25.
//

import Foundation

final class DefaultChatsRepository {
    private let newDataTransferService: DataTransferService
    private let cache: ChatContactsResponseStorage
    private let backgroundQueue: DataTransferDispatchQueue
    
    init(
        newDataTransferService: DataTransferService,
        cache: ChatContactsResponseStorage,
        backgroundQueue: DataTransferDispatchQueue
    ) {
        self.newDataTransferService = newDataTransferService
        self.cache = cache
        self.backgroundQueue = backgroundQueue
    }
}

extension DefaultChatsRepository: IChatContactsRepository {
    func fetchChatContactsList(
        cached: @escaping (ChatContactsPage) -> Void,
        completion: @escaping (Result<ChatContactsPage, Error>) -> Void
    ) -> Cancellable? {
        
    }
}
