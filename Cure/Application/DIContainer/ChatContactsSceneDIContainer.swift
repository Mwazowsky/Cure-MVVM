import UIKit
import SwiftUI

final class ChatContactsDIContainer: ChatContactsListFlowCoordinatorDependencies {
    
    struct Dependencies {
        let apiDataTransferService: DataTransferService
        let newApiDataTransferervice: DataTransferService
        let imageDataTransferService: DataTransferService
    }
    
    private let dependencies: Dependencies
    
    // MARK: - Persistent Storage
    /// ChatContacts
    lazy var chatContactsQueriesStorage: ChatContactsQueriesStorage  = CoreDataChatContactsQueriesStorage(maxStorageLimit: 10)
    lazy var chatContactsResponseCache : ChatContactsResponseStorage = CoreDataChatContactsResponseStorage()
    
    /// Chatting
    lazy var chattingQueriesStorage: ChattingQueriesStorage  = CoreDataChattingsQueriesStorage(maxStorageLimit: 10)
    lazy var chattingsResponseCache : ChattingResponseStorage = CoreDataChattingResponseStorage()
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies       
    }
    
    // MARK: - Use Cases
    func makeFetchContactsUseCase() -> FetchChatContactsUseCase {
        DefaultFetchChatContactsUseCase(
            chatContactsRepository: makeChatContactsRepository(),
            chatsContactsQueriesRepository: makeChatContactsQueriesRepository()
        )
    }
    
    func makeFetchMessagesUseCase() -> FetchMessagesUseCase {
        DefaultFetchMessagesUseCase(
            fetchMessageRepository: makeFetchMessageRepository(),
            messagesQueryRepository: makeChattingQueriesRepository()
        )
    }
    
    func makeGetCurrentUserTokenUseCase() -> GetUserTokenUseCase {
        return DefaultGetCurrentUserTokenUseCase(keychainRepository: makeKeychainRepository())
    }
    
    // MARK: - Repositories
    func makeChatContactsRepository() -> IChatContactsRepository {
        DefaultChatContactsRepository(
            newDataTransferService: dependencies.newApiDataTransferervice,
            cache: chatContactsResponseCache
        )
    }
    
    func makeFetchMessageRepository() -> IChattingRepository {
        DefaultChattingRepository(
            newDataTransferService: dependencies.newApiDataTransferervice,
            cache: chattingsResponseCache
        )
    }
    
    func makeChatContactsQueriesRepository() -> IChatContactsQueriesRepository {
        DefaultChatContactsQueriesRepository(
            chatContactsQueriesPersistentStorage: chatContactsQueriesStorage
        )
    }
    
    func makeChattingQueriesRepository() -> IChattingQueriesRepository {
        DefaultChattingQueriesRepository(
            chattingQueriesPersistentStorage: chattingQueriesStorage
        )
    }
    
    private func makeKeychainRepository() -> IKeychainRepository {
        return DefaultKeychainRepository()
    }
    
    
    // MARK: - Chat Contacts List
    func makeChatContactsListViewController(actions: ChatContactsViewModelActions) -> UIViewController {
        //        if #available(iOS 13.0, *) {
        //            // SwiftUI
        //            let view = ChatContactsView(
        //                viewModelWrapper: makeChatContactsViewModelWrapper(actions: actions)
        //            )
        //            return UIHostingController(rootView: view)
        //        } else {
        // UIKit
        return ChatContactListViewController.create(
            with: makeChatContactsListViewModel(actions: actions)
        )
        //        }
    }
    
    func makeChatContactsListViewModel(actions: ChatContactsViewModelActions) -> ChatContactsViewModel {
        DefaultChatContactsViewModel(
            fetchChatContactsUseCase: makeFetchContactsUseCase(),
            getUserTokenDataUseCase: makeGetCurrentUserTokenUseCase(),
            actions: actions
        )
    }
    
    func makeChattingListViewModel(chatContact: ChatContact) -> ChattingViewModel {
        DefaultChattingViewModel(
            chatContact: chatContact,
            fetchMessagesUseCase: makeFetchMessagesUseCase(),
            getUserTokenDataUseCase: makeGetCurrentUserTokenUseCase()
        )
    }
    
    func makeChattingViewController(chatContact: ChatContact) -> UIViewController {
        return ChattingViewController.create(
            with: makeChattingListViewModel(chatContact: chatContact)
        )
    }
    
    func makeChatContactsDetailsViewController(chatContact: ChatContact) -> UIViewController {
        return UIViewController()
    }
    
    func makeChatContactsQueriesSuggestionsListViewController(
        didSelect: @escaping ChatContactsQueryListViewModelDidSelectAction
    ) -> UIViewController {
        return UIViewController()
    }
    
    
    // MARK: - ViewModelWrapper (For SwiftUI)
    @available(iOS 13.0, *)
    func makeChatContactsViewModelWrapper(
        actions: ChatContactsViewModelActions
    ) -> ChatContactsViewModelWrapper {
        ChatContactsViewModelWrapper(
            viewModel: makeChatContactsListViewModel(actions: actions)
        )
    }
    
    // MARK: - Flow Coordinators
    func makeChatContactsListFlowCoordinator(
        navigationController: UINavigationController,
        appDIContainer: AppDIContainer
    ) -> ChatContactsListFlowCoordinator {
        ChatContactsListFlowCoordinator(
            navigationController: navigationController,
            appDIContainer: appDIContainer,
            dependencies: self
        )
    }
}
