import Foundation

struct ChatContactQueriesListUDS: Codable {
    var list: [ChatContactQueryUDS]
}

struct ChatContactQueryUDS: Codable {
    let query: String
}

extension ChatContactQueryUDS {
    init(ChatContactQuery: ChatContactQuery) {
        query = ChatContactQuery.query
    }
}

extension ChatContactQueryUDS {
    func toDomain() -> ChatContactQuery {
        return .init(query: query)
    }
}
