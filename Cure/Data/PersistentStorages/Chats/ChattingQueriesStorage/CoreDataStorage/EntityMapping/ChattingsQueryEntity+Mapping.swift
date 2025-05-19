import Foundation
import CoreData

extension ChattingQueryEntity {
    convenience init(chattingQuery: ChattingQuery, insertInto context: NSManagedObjectContext) {
        self.init(context: context)
        query = chattingQuery.query
        createdAt = Date()
    }
}

extension ChattingQueryEntity {
    func toDomain() -> ChattingQuery {
        return .init(query: query ?? "")
    }
}
