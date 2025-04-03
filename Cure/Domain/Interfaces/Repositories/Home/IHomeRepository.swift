import Foundation

protocol IHomeRepository {
    @discardableResult
    func fetchHomeList(
        query: HomeQuery,
        page: Int,
        cached: @escaping (HomePage) -> Void,
        completion: @escaping (Result<HomePage, Error>) -> Void
    ) -> Cancellable?
}
