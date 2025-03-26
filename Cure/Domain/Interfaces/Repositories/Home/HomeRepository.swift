import Foundation

protocol HomeRepository {
    @discardableResult
    func fetchHomeList(
        query: HomeQuery,
        page: Int,
        cached: @escaping (HomePage) -> Void,
        completion: @escaping (Result<HomePage, Error>) -> Void
    ) -> Cancellable?
}
