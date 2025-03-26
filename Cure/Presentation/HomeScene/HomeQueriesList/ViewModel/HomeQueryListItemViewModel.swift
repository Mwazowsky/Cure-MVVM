import Foundation

class HomeQueryListItemViewModel {
    let query: String

    init(query: String) {
        self.query = query
    }
}

extension HomeQueryListItemViewModel: Equatable {
    static func == (lhs: HomeQueryListItemViewModel, rhs: HomeQueryListItemViewModel) -> Bool {
        return lhs.query == rhs.query
    }
}
