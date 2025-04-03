import Foundation

// This is another option to create Use Case using more generic way
final class FetchRecentHomeQueriesUseCase: UseCase {

    struct RequestValue {
        let maxCount: Int
    }
    typealias ResultValue = (Result<[HomeQuery], Error>)

    private let requestValue: RequestValue
    private let completion: (ResultValue) -> Void
    private let homeQueriesRepository: IHomeQueriesRepository

    init(
        requestValue: RequestValue,
        completion: @escaping (ResultValue) -> Void,
        homeQueriesRepository: IHomeQueriesRepository
    ) {

        self.requestValue = requestValue
        self.completion = completion
        self.homeQueriesRepository = homeQueriesRepository
    }
    
    func start() -> Cancellable? {

        homeQueriesRepository.fetchRecentsQueries(
            maxCount: requestValue.maxCount,
            completion: completion
        )
        return nil
    }
}
