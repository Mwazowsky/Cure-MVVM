import Foundation

typealias HomeQueryListViewModelDidSelectAction = (HomeQuery) -> Void

protocol HomeQueryListViewModelInput {
    func viewWillAppear()
    func didSelect(item: HomeQueryListItemViewModel)
}

protocol HomeQueryListViewModelOutput {
    var items: Observable<[HomeQueryListItemViewModel]> { get }
}

protocol HomeQueryListViewModel: HomeQueryListViewModelInput, HomeQueryListViewModelOutput { }

typealias FetchRecentHomeQueriesUseCaseFactory = (
    FetchRecentHomeQueriesUseCase.RequestValue,
    @escaping (FetchRecentHomeQueriesUseCase.ResultValue) -> Void
) -> UseCase

final class DefaultHomeQueryListViewModel: HomeQueryListViewModel {

    private let numberOfQueriesToShow: Int
    private let fetchRecentHomeQueriesUseCaseFactory: FetchRecentHomeQueriesUseCaseFactory
    private let didSelect: HomeQueryListViewModelDidSelectAction?
    private let mainQueue: DispatchQueueType
    
    // MARK: - OUTPUT
    let items: Observable<[HomeQueryListItemViewModel]> = Observable([])
    
    init(
        numberOfQueriesToShow: Int,
        fetchRecentHomeQueriesUseCaseFactory: @escaping FetchRecentHomeQueriesUseCaseFactory,
        didSelect: HomeQueryListViewModelDidSelectAction? = nil,
        mainQueue: DispatchQueueType = DispatchQueue.main
    ) {
        self.numberOfQueriesToShow = numberOfQueriesToShow
        self.fetchRecentHomeQueriesUseCaseFactory = fetchRecentHomeQueriesUseCaseFactory
        self.didSelect = didSelect
        self.mainQueue = mainQueue
    }
    
    private func updateHomeQueries() {
        let request = FetchRecentHomeQueriesUseCase.RequestValue(maxCount: numberOfQueriesToShow)
        let completion: (FetchRecentHomeQueriesUseCase.ResultValue) -> Void = { [weak self] result in
            self?.mainQueue.async {
                switch result {
                case .success(let items):
                    self?.items.value = items
                        .map { $0.query }
                        .map(HomeQueryListItemViewModel.init)
                case .failure:
                    break
                }
            }
        }
        let useCase = fetchRecentHomeQueriesUseCaseFactory(request, completion)
        useCase.start()
    }
}

// MARK: - INPUT. View event methods
extension DefaultHomeQueryListViewModel {
        
    func viewWillAppear() {
        updateHomeQueries()
    }
    
    func didSelect(item: HomeQueryListItemViewModel) {
        didSelect?(HomeQuery(query: item.query))
    }
}
