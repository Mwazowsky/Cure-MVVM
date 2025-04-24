//
//  CoreDataChatContactsResponseStorage.swift
//  Cure
//
//  Created by Saifulloh Fadli on 24/04/25.
//

import Foundation
import CoreData

final class CoreDataChatContactsResponseStorage {
    private let coreDataStorage: CoreDataStorage
    
    init(coreDataStorage: CoreDataStorage = CoreDataStorage.shared) {
        self.coreDataStorage = coreDataStorage
    }
    
    // MARK: - Private
    private func fetchRequest(
        for requestDto: ChatContactsRequestDTO
    ) -> NSFetchRequest<ChatContactsRequestEntity> {
        let request: NSFetchRequest = ChatContactsRequestEntity.fetchRequest()
        request.predicate = NSPredicate(format: "%K = %@ AND %K = %d",
                                        #keyPath(ChatContactsRequestEntity.filter), requestDto.filter,
                                        #keyPath(ChatContactsRequestEntity.page), requestDto.page,
                                        #keyPath(ChatContactsRequestEntity.size), requestDto.size)
        
        return request
    }
    
    private func deleteResponse(
        for requestDto: ChatContactsRequestDTO,
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

extension CoreDataChatContactsResponseStorage: ChatContactsResponseStorage {
    func getResponse(
        for requestDto: ChatContactsRequestDTO,
        completion: @escaping (Result<ChatContactsPageDTO, any Error>) -> Void
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
        responseDto: ChatContactsPageDTO,
        for requestDto: ChatContactsRequestDTO
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
        for requestDto: ChatContactsRequestDTO,
        completion: @escaping (ChatContactsPageDTO?) -> Void
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
