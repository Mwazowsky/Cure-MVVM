//
//  ChatListViewModel.swift
//  Cure
//
//  Created by MacBook Air MII  on 2/5/25.
//

import Foundation

struct ChatContactsListViewModelActions {
    /// Note: if you would need to edit movie inside Details screen and update this Movies List screen with updated movie then you would need this closure:
    /// showMovieDetails: (Movie, @escaping (_ updated: Movie) -> Void) -> Void
    let showChattingPage: (ChatContact) -> Void
    let showChatContactDetails: (ChatContact) -> Void
    let showChatContactsQueriesSuggestions: (@escaping (_ didSelect: ChatContactQuery) -> Void) -> Void
    let closeChatContactsQueriesSuggestions: () -> Void
}

enum ChatContactsListViewModelLoading {
    case fullScreen
    case nextPage
}

protocol ChatContactsListViewModelInput {
    func viewDidLoad()
    func didLoadNextPage()
    func didSearch(query: String)
    func didCancelSearch()
    func showQueriesSuggestions()
    func closeQueriesSuggestions()
    func didSelectItem(at index: Int)
}

protocol ChatContactsListViewModelOutput {
    var items: Observable<[ChatContactsListItemViewModel]> { get } /// Also we can calculate view model items on demand:  https://github.com/kudoleh/iOS-Clean-Architecture-MVVM/pull/10/files
    var loading: Observable<ChatContactsListViewModelLoading?> { get }
    var query: Observable<String> { get }
    var error: Observable<String> { get }
    var isEmpty: Bool { get }
    var screenTitle: String { get }
    var emptyDataTitle: String { get }
    var errorTitle: String { get }
    var searchBarPlaceholder: String { get }
}

typealias ChatContactsViewModel = ChatContactsListViewModelInput & ChatContactsListViewModelOutput

final class DefaultChatContactsViewModel: ChatContactsViewModel {
    
    private let fetchChatContactsUseCase: FetchChatContactsUseCase
    private let getUserTokenDataUseCase: GetUserTokenUseCase
    private let actions: ChatContactsListViewModelActions?
    
    var currentPage: Int = 0
    var totalPageCount: Int = 1
    var hasMorePages: Bool { currentPage < totalPageCount }
    var nextPage: Int { hasMorePages ? currentPage + 1 : currentPage }
    
    private var pages: [ChatContactsPage] = [] // - <Base Response from api>
    private var chatContactsLoadTask: Cancellable? { willSet { chatContactsLoadTask?.cancel() } }
    private let mainQueue: DispatchQueueType
    
    // MARK: - OUTPUT
    let items: Observable<[ChatContactsListItemViewModel]> = Observable([])
    let loading: Observable<ChatContactsListViewModelLoading?> = Observable(.none)
    let query: Observable<String> = Observable("")
    let error: Observable<String> = Observable("")
    var isEmpty: Bool { return items.value.isEmpty }
    let screenTitle = NSLocalizedString("Movies", comment: "")
    let emptyDataTitle = NSLocalizedString("Search results", comment: "")
    let errorTitle = NSLocalizedString("Error", comment: "")
    let searchBarPlaceholder = NSLocalizedString("Search Movies", comment: "")
    
    // MARK: - Init
    init(
        fetchChatContactsUseCase: FetchChatContactsUseCase,
        getUserTokenDataUseCase: GetUserTokenUseCase,
        actions: ChatContactsListViewModelActions? = nil,
        mainQueue: DispatchQueueType = DispatchQueue.main
    ) {
        self.fetchChatContactsUseCase = fetchChatContactsUseCase
        self.getUserTokenDataUseCase = getUserTokenDataUseCase
        self.actions = actions
        self.mainQueue = mainQueue
    }
    
    // MARK: - Private
    private func appendPage(_ chatContactsPage: ChatContactsPage) {
        currentPage = chatContactsPage.page
        totalPageCount = chatContactsPage.page
        
        pages = pages
            .filter { $0.page != chatContactsPage.page }
        + [chatContactsPage]
        
        items.value = pages
            .flatMap { $0.chatContacts }
            .map(ChatContactsListItemViewModel.init)
    }
    
    private func resetPages() {
        currentPage = 0
        totalPageCount = 1
        pages.removeAll()
        items.value.removeAll()
    }
    
    private func load(chatContactQuery: ChatContactQuery, loading: ChatContactsListViewModelLoading) {
        self.loading.value = loading

        query.value = chatContactQuery.query
        print("Did run execute fetch chat contact")

        chatContactsLoadTask = fetchChatContactsUseCase.execute(
            requestValue: .init(query: chatContactQuery, page: nextPage, size: 10),
            cached: { page in
//                self?.mainQueue.async {
//                    /// Error: Execute Cached completion return dto of chat contact
//                    /// instead of the entire page that contain its metadata
//                    self?.appendChatContactPage(page)
//                }
                print("Page: ", page) // DebugPoint 1 - Cache Related
            },
            completion: { [weak self] result in
                self?.mainQueue.async {
                    switch result {
                    case .success(let page):
                        print("Page Chat Contact: ", page)
                        self?.appendPage(page)
                    case .failure(let error):
                        print("Page Chat Contact error: ", error)
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
    
    private func update(chatContactsQuery: ChatContactQuery) {
        resetPages()
        load(
            chatContactQuery: chatContactsQuery,
            loading: .fullScreen
        )
    }
    
    //    private func setupNotificationSocket() {
    //        NotificationCenter.default.addObserver(self, selector: #selector(handlerNewMessage(notification:)), name: .socketNewMessage, object: nil)
    //        NotificationCenter.default.addObserver(self, selector: #selector(handlerNewContactPaired(notification:)), name: .socketContactPaired, object: nil)
    //    }
    //
    //    @objc
    //    func handlerNewMessage(notification: Notification) {
    //        self.getNewChat(huntingNumber: currentHuntingNumber?.companyHuntingNumberID)
    //    }
    //
    //    @objc
    //    func handlerNewContactPaired(notification: Notification) {
    //        self.isCanPagination = true
    //        self.currentPage = 1
    //        self.getListChatContact(huntingNumber: currentHuntingNumber?.companyHuntingNumberID) { contactName in
    //            //            let toast = Toast.text("\(contactName) Baru Dipasangkan ke Anda")
    //            //            toast.show()
    //        }
    //    }
}

extension DefaultChatContactsViewModel {
    
    func viewDidLoad() {
        if let token = getUserTokenDataUseCase.execute()?.token {
            TokenManager.shared.configure(token: token)
            
            load(
                chatContactQuery: .init(query: query.value),
                loading: .fullScreen
            )
        }
    }
    
    func didLoadNextPage() {
        guard hasMorePages, loading.value == .none else { return }
        load(
            chatContactQuery: .init(query: query.value),
            loading: .nextPage
        )
    }
    
    func didSearch(query: String) {
        guard !query.isEmpty else { return }
        update(
            chatContactsQuery: ChatContactQuery(query: query)
        )
    }
    
    func didCancelSearch() {
        chatContactsLoadTask?.cancel()
    }
    
    func showQueriesSuggestions() {
        actions?.showChatContactsQueriesSuggestions(update(chatContactsQuery:))
    }
    
    func closeQueriesSuggestions() {
        actions?.closeChatContactsQueriesSuggestions()
    }
    
    func didSelectItem(at index: Int) {
        let allContacts = pages.flatMap { $0.chatContacts }
        let selectedContact = allContacts[index]
        actions?.showChatContactDetails(selectedContact)
    }
}
