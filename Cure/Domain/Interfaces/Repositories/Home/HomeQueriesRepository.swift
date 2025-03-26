import Foundation

protocol HomeQueriesRepository {
    func fetchRecentsQueries(
        maxCount: Int,
        completion: @escaping (Result<[HomeQuery], Error>) -> Void
    )
    
    func saveRecentQuery(
        query: HomeQuery,
        completion: @escaping (Result<HomeQuery, Error>) -> Void
    )
}
