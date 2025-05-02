import Foundation

final class UserDefaultsChatContactsQueriesStorage {
    private let maxStorageLimit: Int
    private let recentsChatContactsQueriesKey = "recentsChatContactsQueries"
    private var userDefaults: UserDefaults
    private let backgroundQueue: DispatchQueueType
    
    init(
        maxStorageLimit: Int,
        userDefaults: UserDefaults = UserDefaults.standard,
        backgroundQueue: DispatchQueueType = DispatchQueue.global(qos: .userInitiated)
    ) {
        self.maxStorageLimit = maxStorageLimit
        self.userDefaults = userDefaults
        self.backgroundQueue = backgroundQueue
    }

    private func fetchChatContactsQueries() -> [ChatContactQuery] {
        if let queriesData = userDefaults.object(forKey: recentsChatContactsQueriesKey) as? Data {
            if let chatContactQueryList = try? JSONDecoder().decode(ChatContactQueriesListUDS.self, from: queriesData) {
                return chatContactQueryList.list.map { $0.toDomain() }
            }
        }
        return []
    }

    private func persist(chatContactsQueries: [ChatContactQuery]) {
        let encoder = JSONEncoder()
        let chatContactQueryUDSs = chatContactsQueries.map(ChatContactQueryUDS.init)
        if let encoded = try? encoder.encode(ChatContactQueriesListUDS(list: chatContactQueryUDSs)) {
            userDefaults.set(encoded, forKey: recentsChatContactsQueriesKey)
        }
    }
}

extension UserDefaultsChatContactsQueriesStorage: ChatContactsQueriesStorage {

    func fetchRecentsQueries(
        maxCount: Int,
        completion: @escaping (Result<[ChatContactQuery], Error>) -> Void
    ) {
        backgroundQueue.async { [weak self] in
            guard let self = self else { return }

            var queries = self.fetchChatContactsQueries()
            queries = queries.count < self.maxStorageLimit ? queries : Array(queries[0..<maxCount])
            completion(.success(queries))
        }
    }

    func saveRecentQuery(
        query: ChatContactQuery,
        completion: @escaping (Result<ChatContactQuery, Error>) -> Void
    ) {
        backgroundQueue.async { [weak self] in
            guard let self = self else { return }

            var queries = self.fetchChatContactsQueries()
            self.cleanUpQueries(for: query, in: &queries)
            queries.insert(query, at: 0)
            self.persist(chatContactsQueries: queries)

            completion(.success(query))
        }
    }
}


// MARK: - Private
extension UserDefaultsChatContactsQueriesStorage {

    private func cleanUpQueries(for query: ChatContactQuery, in queries: inout [ChatContactQuery]) {
        removeDuplicates(for: query, in: &queries)
        removeQueries(limit: maxStorageLimit - 1, in: &queries)
    }

    private func removeDuplicates(for query: ChatContactQuery, in queries: inout [ChatContactQuery]) {
        queries = queries.filter { $0 != query }
    }

    private func removeQueries(limit: Int, in queries: inout [ChatContactQuery]) {
        queries = queries.count <= limit ? queries : Array(queries[0..<limit])
    }
}
