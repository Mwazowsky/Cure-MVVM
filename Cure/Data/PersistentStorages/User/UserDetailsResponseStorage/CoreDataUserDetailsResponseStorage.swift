//
//  CoreDataUserDetailsResponseStorage.swift
//  Cure
//
//  Created by MacBook Air MII  on 16/4/25.
//

import Foundation
import CoreData

final class CoreDataUserDetailsResponseStorage {
    private let coreDataStorage: CoreDataStorage
    
    init(coreDataStorage: CoreDataStorage = CoreDataStorage.shared) {
        self.coreDataStorage = coreDataStorage
    }
    
    // MARK: - Private
    private func fetchCurrentUserRequest() -> NSFetchRequest<UserDetailsResponseEntity> {
        let request: NSFetchRequest<UserDetailsResponseEntity> = UserDetailsResponseEntity.fetchRequest()
        request.fetchLimit = 1
        return request
    }
    
    private func deleteCurrentUser(withId employeeID: String, in context: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<UserDetailsResponseEntity> = UserDetailsResponseEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "employeeID == %@", employeeID)
        
        do {
            let result = try context.fetch(fetchRequest)
            result.forEach { context.delete($0)}
        } catch {
            print("Failed to delete existing user: \(error)")
        }
    }
}

extension CoreDataUserDetailsResponseStorage: UserDetailsResponseStorage {
    
    func getResponse(completion: @escaping (Result<UserDetailsResponse?, DataTransferError>) -> Void) {
        coreDataStorage.performBackgroundTask { context in
            do {
                let fetchRequest = UserBaseResponseEntity.fetchRequest()
                let requestEntity = try context.fetch(fetchRequest).first

                if (requestEntity?.toDTO()) != nil {
                    completion(.success(requestEntity?.toDTO()))
                } else {
                    completion(.failure(DataTransferError.parsing(AuthenticationError.unknownError)))
                }
            } catch {
                completion(.failure(DataTransferError.parsing(AuthenticationError.unknownError)))
            }
        }

    }
    
    func save(response: UserDetailsDTO) {
        coreDataStorage.performBackgroundTask { context in
            do {
                self.deleteCurrentUser(withId: String(response.employeeID), in: context)
                
                _ = response.toEntitiy(in: context)
                
                try context.save()
            } catch {
                debugPrint("Error saving context: \(error)")
            }
        }
    }
}
