import Foundation

final class DefaultChatContactsQueriesRepository {
    
    private var chatContactsQueriesPersistentStorage: ChatContactsQueriesStorage
    
    init(chatContactsQueriesPersistentStorage: ChatContactsQueriesStorage) {
        self.chatContactsQueriesPersistentStorage = chatContactsQueriesPersistentStorage
    }
}

extension DefaultChatContactsQueriesRepository: IChatContactsQueriesRepository {
    func fetchRecentsQueries(
        maxCount: Int,
        completion: @escaping (Result<[ChatContactQuery], Error>) -> Void
    ) {
        return chatContactsQueriesPersistentStorage.fetchRecentsQueries(
            maxCount: maxCount,
            completion: completion
        )
    }
    
    func saveRecentQuery(
        query: ChatContactQuery,
        completion: @escaping (Result<ChatContactQuery, Error>) -> Void
    ) {
        chatContactsQueriesPersistentStorage.saveRecentQuery(
            query: query,
            completion: completion
        )
    }
}
