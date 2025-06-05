//
//  ChattingViewModel.swift
//  Cure
//
//  Created by MacBook Air MII  on 19/5/25.
//

import Foundation


// Models
/// ChatMessage -> Individual Message entity
/// MessagesPage -> Base response from api with data containing array of ChatMessage
///


struct ChattingViewModelActions {
    let showChatContactDetails: (ChatContact) -> Void
    let showMessageDetails: (ChatMessage) -> Void
    let showChattingQueries: (@escaping (_ didSelect: ChattingQuery) -> Void) -> Void
    let closeChattingQueries: () -> Void
}

enum ChattingViewModelLoading {
    case fullscreen
    case nextPage
}

protocol ChattingViewModelInput {
    func viewDidLoad()
    func didLoadNextPage()
    func didSearch(query: String)
    func didCancelSearch()
    func showQueriesSuggestions()
    func closeQueriesSuggestions()
    func didSelectItem(at index: Int)
}

protocol ChattingViewModelOutput {
    var items: Observable<[ChattingListItemViewModel]> { get }
    var loading: Observable<ChattingViewModelLoading?> { get }
    var query: Observable<String> { get }
    var error: Observable<String> { get }
    var isEmpty: Bool { get }
    var screenTitle: String { get }
    var emptyDataTitle: String { get }
    var errorTitle: String { get }
    var searchBarPlaceholder: String { get }
}

typealias ChattingViewModel = ChattingViewModelInput & ChattingViewModelOutput

final class DefaultChattingViewModel: ChattingViewModel {
    private let fetchMessagesUseCase: FetchMessagesUseCase
    private let getUserTokenDataUseCase: GetUserTokenUseCase
    private let actions: ChattingViewModelActions?
    private let chatContact: ChatContact
    
    var currentPage: Int = 0
    var totalPageCount: Int = 1
    var hasMorePages: Bool { currentPage < totalPageCount }
    var nextPage: Int { hasMorePages ? currentPage + 1 : currentPage }
    
    private var pages: [ChatMessagesPage] = []
    private var chattingLoadTask: Cancellable? { willSet { chattingLoadTask?.cancel() } }
    private let mainQueue: DispatchQueueType
    
    // MARK: - Output
    let items: Observable<[ChattingListItemViewModel]> = Observable([])
    let loading: Observable<ChattingViewModelLoading?> = Observable(.none)
    let query: Observable<String> = Observable("")
    let error: Observable<String> = Observable("")
    var isEmpty: Bool { return items.value.isEmpty }
    let screenTitle = NSLocalizedString("Nama Contact", comment: "")
    let emptyDataTitle = NSLocalizedString("Search results", comment: "")
    let errorTitle = NSLocalizedString("Error", comment: "")
    let searchBarPlaceholder = NSLocalizedString("Search Message", comment: "")
    
    // MARK: - Init
    init(
        chatContact: ChatContact,
        fetchMessagesUseCase: FetchMessagesUseCase,
        getUserTokenDataUseCase: GetUserTokenUseCase,
        actions: ChattingViewModelActions? = nil,
        mainQueue: DispatchQueueType = DispatchQueue.main
    ) {
        self.chatContact = chatContact
        self.fetchMessagesUseCase = fetchMessagesUseCase
        self.getUserTokenDataUseCase = getUserTokenDataUseCase
        self.actions = actions
        self.mainQueue = mainQueue
    }
    
    // MARK: - Private
    private func appendPage(_ messagesPage: ChatMessagesPage) {
        currentPage = messagesPage.page
        totalPageCount = messagesPage.totalPages
        
        pages = pages
            .filter { $0.page != currentPage }
        + [messagesPage]
        
//        items.value = pages
//            .flatMap { $0.chatMessages }
//            .map(ChattingListItemViewModel.init)
    }
    
    private func resetPages() {
        currentPage = 0
        totalPageCount = 1
        pages.removeAll()
        items.value.removeAll()
    }
    
    private func load(chattingQuery: ChattingQuery, loading: ChattingViewModelLoading) {
        self.loading.value = loading
        query.value = chattingQuery.query
        
        chattingLoadTask = fetchMessagesUseCase.execute(
            requestValue: .init(
                messageChannel: chatContact.channelName ?? "",
                query: chattingQuery,
                companyHuntingNumberId: chatContact.companyHuntingNumberID,
                contactId: chatContact.contactID,
                contactPairingId: chatContact.contactPairingID,
                page: nextPage,
                size: 100,
                totalPages: totalPageCount),
            cached: { page in
                //                self?.mainQueue.async {
                //                    /// Error: Execute Cached completion return dto of chat contact
                //                    /// instead of the entire page that contain its metadata
                //                    self?.appendChatContactPage(page)
                //                }
            },
            completion: { [weak self] result in
                self?.mainQueue.async {
                    switch result {
                    case .success(let page):
                        let pageDM = page
                        self?.appendPage(pageDM)
                    case .failure(let error):
                        self?.handle(error: error)
                    }
                    self?.loading.value = .none
                }
            }
        )
    }
    
    private func handle(error: Error) {
        self.error.value = error.isInternetConnectionError ?
        NSLocalizedString("No internet connection", comment: "") :
        NSLocalizedString("Failed loading movies", comment: "")
    }
    
    private func update(chattingQuery: ChattingQuery) {
        resetPages()
        load(
            chattingQuery: chattingQuery,
            loading: .fullscreen
        )
    }
}

extension DefaultChattingViewModel {
    func viewDidLoad() {
        if let token = getUserTokenDataUseCase.execute()?.token {
            TokenManager.shared.configure(token: token)
            
            load(
                chattingQuery: .init(query: query.value),
                loading: .fullscreen
            )
        }
    }
    
    func didLoadNextPage() {
        guard hasMorePages, loading.value == .none else { return }
        
        load(
            chattingQuery: .init(query: query.value),
            loading: .nextPage
        )
    }
    
    func didSearch(query: String) {
        guard !query.isEmpty else { return }
        update(
            chattingQuery: ChattingQuery(query: query)
        )
    }
    
    func didCancelSearch() {
        chattingLoadTask?.cancel()
    }
    
    func showQueriesSuggestions() {
        actions?.showChattingQueries(update(chattingQuery:))
    }
    
    func closeQueriesSuggestions() {
        actions?.closeChattingQueries()
    }
    
    func didSelectItem(at index: Int) {
//        let allMessages = pages.flatMap { $0.chatMessages }
//        let _ = allMessages[index]
//        actions?.showChatContactDetails(selectedMessage)
    }
}
