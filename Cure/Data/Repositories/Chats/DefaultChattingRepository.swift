//
//  DefaultChattingRepository.swift
//  Cure
//
//  Created by MacBook Air MII  on 19/5/25.
//

import Foundation

final class DefaultChattingRepository {
    private let newDataTransferService: DataTransferService
    private let cache: ChattingResponseStorage
    private let backgroundQueue: DataTransferDispatchQueue
    
    init(
        newDataTransferService: DataTransferService,
        cache: ChattingResponseStorage,
        backgroundQueue: DataTransferDispatchQueue = DispatchQueue.global(qos: .userInitiated)
    ) {
        self.newDataTransferService = newDataTransferService
        self.cache = cache
        self.backgroundQueue = backgroundQueue
    }
}

extension DefaultChattingRepository: IChattingRepository {
    func fetchMessages(
        messageChannel: String,
        query: ChattingQuery,
        companyHuntingNumberId: Int,
        contactId: Int,
        contactPairingId: Int,
        page: Int,
        size: Int,
        totalPages: Int,
        cached: @escaping (MessagesPageDTO) -> Void,
        completion: @escaping (Result<MessagesPageDTO, any Error>) -> Void
    ) -> Cancellable? {
        let requestDto = ChattingRequestDTO(
            filter: query.query,
            companyHuntingNumberId: companyHuntingNumberId,
            contactId: contactId,
            contactPairingID: contactPairingId,
            page: page,
            size: size,
            totalPages: totalPages
        )
        let task = RepositoryTask()
        
        cache.getResponse(for: requestDto) { result in
            switch result {
            case .success(let responseDto):
                cached(responseDto)
            case .failure(let error):
                print("Failed to fetch cached chat contacts: \(error)")
            }
            
            guard !task.isCancelled else { return }
            
            let endpoint = APIEndpoints.getChatMessages(with: requestDto, messageChannel: messageChannel)
            
            print("Message endpoint in Repository: ", endpoint)
            
            task.networkTask = self.newDataTransferService.request(
                with: endpoint,
                on: self.backgroundQueue
            ) { [weak self] (result: Result<BaseResponse<MessageResponseDTO>, DataTransferError>) in
                switch result {
                case .success(let baseResponse):
                    print("baseResponse.data ?? []: ", baseResponse.data)
                    
                    let responseDTO = MessagesPageDTO(
                        filter: requestDto.filter,
                        timeStamp: Date(),
                        page: requestDto.page,
                        size: requestDto.size,
                        totalPages: requestDto.totalPages
//                        chatMessages: baseResponse.data ?? MessageResponseDTO(reply: nil, detail: nil, base: nil)
                    )
                    
                    print("Message response in Repository: ", baseResponse)
                    
                    self?.cache.save(responseDto: responseDTO, for: requestDto)
                    completion(.success(responseDTO))

                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        
        return task
    }
}
