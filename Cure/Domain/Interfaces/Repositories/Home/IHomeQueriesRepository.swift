import Foundation

protocol IHomeQueriesRepository {
    func fetchRecentsQueries(
        maxCount: Int,
        completion: @escaping (Result<[HomeQuery], Error>) -> Void
    )
    
    func saveRecentQuery(
        query: HomeQuery,
        completion: @escaping (Result<HomeQuery, Error>) -> Void
    )
}
