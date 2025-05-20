//
//  CoreDataChatContactsResponseStorage.swift
//  Cure
//
//  Created by Saifulloh Fadli on 24/04/25.
//

import Foundation
import CoreData

final class CoreDataChattingResponseStorage {
    private let coreDataStorage: CoreDataStorage
    
    init(coreDataStorage: CoreDataStorage = CoreDataStorage.shared) {
        self.coreDataStorage = coreDataStorage
    }
    
    // MARK: - Private
    private func fetchRequest(
        for requestDto: ChattingRequestDTO
    ) -> NSFetchRequest<ChattingsRequestEntity> {
        let request: NSFetchRequest = ChattingsRequestEntity.fetchRequest()
        request.predicate = NSPredicate(format: "%K = %@ AND %K = %d",
                                        #keyPath(ChattingsRequestEntity.filter), requestDto.filter,
                                        #keyPath(ChattingsRequestEntity.page), requestDto.page,
                                        #keyPath(ChattingsRequestEntity.size), requestDto.size)
        
        return request
    }
    
    private func deleteResponse(
        for requestDto: ChattingRequestDTO,
        in context: NSManagedObjectContext
    ) {
        let request = fetchRequest(for: requestDto)
        
        do {
            if let result = try context.fetch(request).first {
                context.delete(result)
            }
        } catch {
            print(error)
        }
    }
}

extension CoreDataChattingResponseStorage: ChattingResponseStorage {
    func getResponse(
        for requestDto: ChattingRequestDTO,
        completion: @escaping (Result<MessagesPageDTO, any Error>) -> Void
    ) {
        coreDataStorage.performBackgroundTask { context in
            do {
                let fetchRequest = self.fetchRequest(for: requestDto)
                let requestEntity = try context.fetch(fetchRequest).first

                if let responseDTO = requestEntity?.response?.toDTO() {
                    completion(.success(responseDTO))
                } else {
                    completion(.failure(CoreDataStorageError.readError(NSError(domain: "No cached data found", code: 0))))
                }
            } catch {
                completion(.failure(CoreDataStorageError.readError(error)))
            }
        }
    }
    
    func save(
        responseDto: MessagesPageDTO,
        for requestDto: ChattingRequestDTO
    ) {
        coreDataStorage.performBackgroundTask { context in
            do {
                self.deleteResponse(for: requestDto, in: context)
                
                let requestEntity = requestDto.toEntity(in: context)
                requestEntity.response = responseDto.toEntity(in: context)
                
                try context.save()
            } catch {
                
            }
        }
    }
    
    func load(
        for requestDto: ChattingRequestDTO,
        completion: @escaping (MessagesPageDTO?) -> Void
    ) {
        coreDataStorage.performBackgroundTask { context in
            let fetchRequest = self.fetchRequest(for: requestDto)
            
            do {
                let requestEntity = try context.fetch(fetchRequest).first
                completion(requestEntity?.response?.toDTO())
            } catch {
                print("❌ Failed to load cached chat contacts: \(error)")
                completion(nil)
            }
        }
    }
}
