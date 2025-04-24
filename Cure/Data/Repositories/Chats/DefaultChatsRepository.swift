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
        query: ChatContactQuery,
        page: Int,
        size: Int,
        cached: @escaping (ChatContactsPageDTO) -> Void,
        completion: @escaping (Result<ChatContactsPage, Error>) -> Void
    ) -> Cancellable? {
        let requestDto = ChatContactsRequestDTO(filter: query.query, page: page, size: size)
        let task = RepositoryTask()
        
        cache.getResponse(for: requestDto) { result in
            switch result {
            case .success(let responseDto):
                cached(responseDto)
            case .failure(let error):
                print("Failed to fetch cached chat contacts: \(error)")
            }
            
            guard !task.isCancelled else { return }
            
            let endpoint = APIEndpoints.getChatContacts(with: requestDto)
            
            task.networkTask = self.newDataTransferService.request(
                with: endpoint,
                on: self.backgroundQueue
            ) { [weak self] (result: Result<BaseResponse<[ChatContactResponseDTO]>, DataTransferError>) in
                switch result {
                case .success(let baseResponse):
                    let responseDTO = ChatContactsPageDTO(
                        filter: requestDto.filter,
                        timeStamp: Date(),
                        page: requestDto.page,
                        size: requestDto.size,
                        chatContacts: baseResponse.data ?? []
                    )
                    
                    self?.cache.save(responseDto: responseDTO, for: requestDto)
                    completion(.success(responseDTO.toDomain()))

                case .failure(let error):
                    completion(.failure(error))
                }
            }

        }
        return task
    }
}
