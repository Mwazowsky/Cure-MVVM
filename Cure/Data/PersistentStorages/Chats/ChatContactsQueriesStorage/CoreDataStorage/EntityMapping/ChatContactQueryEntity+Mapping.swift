import Foundation
import CoreData

extension ChatContactQueryEntity {
    convenience init(chatContactQuery: ChatContactQuery, insertInto context: NSManagedObjectContext) {
        self.init(context: context)
        query = chatContactQuery.query
        createdAt = Date()
    }
}

extension ChatContactQueryEntity {
    func toDomain() -> ChatContactQuery {
        return .init(query: query ?? "")
    }
}
