import Foundation
import CoreData

final class CoreDataChatContactsQueriesStorage {

    private let maxStorageLimit: Int
    private let coreDataStorage: CoreDataStorage

    init(
        maxStorageLimit: Int,
        coreDataStorage: CoreDataStorage = CoreDataStorage.shared
    ) {
        self.maxStorageLimit = maxStorageLimit
        self.coreDataStorage = coreDataStorage
    }
}

extension CoreDataChatContactsQueriesStorage: ChatContactsQueriesStorage {
    
    func fetchRecentsQueries(
        maxCount: Int,
        completion: @escaping (Result<[ChatContactQuery], Error>) -> Void
    ) {
        
        coreDataStorage.performBackgroundTask { context in
            do {
                let request: NSFetchRequest = ChatContactQueryEntity.fetchRequest()
                request.sortDescriptors = [NSSortDescriptor(key: #keyPath(ChatContactQueryEntity.createdAt),
                                                            ascending: false)]
                request.fetchLimit = maxCount
                let result = try context.fetch(request).map { $0.toDomain() }

                completion(.success(result))
            } catch {
                completion(.failure(CoreDataStorageError.readError(error)))
            }
        }
    }
    
    func saveRecentQuery(
        query: ChatContactQuery,
        completion: @escaping (Result<ChatContactQuery, Error>) -> Void
    ) {

        coreDataStorage.performBackgroundTask { [weak self] context in
            guard let self = self else { return }
            do {
                try self.cleanUpQueries(for: query, inContext: context)
                let entity = ChatContactQueryEntity(chatContactQuery: query, insertInto: context)
                try context.save()

                completion(.success(entity.toDomain()))
            } catch {
                completion(.failure(CoreDataStorageError.saveError(error)))
            }
        }
    }
}

// MARK: - Private
extension CoreDataChatContactsQueriesStorage {

    private func cleanUpQueries(
        for query: ChatContactQuery,
        inContext context: NSManagedObjectContext
    ) throws {
        let request: NSFetchRequest = ChatContactQueryEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(MovieQueryEntity.createdAt),
                                                    ascending: false)]
        var result = try context.fetch(request)

        removeDuplicates(for: query, in: &result, inContext: context)
        removeQueries(limit: maxStorageLimit - 1, in: result, inContext: context)
    }

    private func removeDuplicates(
        for query: ChatContactQuery,
        in queries: inout [ChatContactQueryEntity],
        inContext context: NSManagedObjectContext
    ) {
        queries
            .filter { $0.query == query.query }
            .forEach { context.delete($0) }
        queries.removeAll { $0.query == query.query }
    }

    private func removeQueries(
        limit: Int,
        in queries: [ChatContactQueryEntity],
        inContext context: NSManagedObjectContext
    ) {
        guard queries.count > limit else { return }

        queries.suffix(queries.count - limit)
            .forEach { context.delete($0) }
    }
}
