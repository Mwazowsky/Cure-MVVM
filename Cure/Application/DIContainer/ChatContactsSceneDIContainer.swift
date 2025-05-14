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
    
    func makeGetCurrentUserTokenUseCase() -> GetUserTokenUseCase {
        return DefaultGetCurrentUserTokenUseCase(keychainRepository: makeKeychainRepository())
    }
    
    // MARK: - Repositories
    func makeChatContactsRepository() -> IChatContactsRepository {
        DefaultChatsRepository(
            newDataTransferService: dependencies.newApiDataTransferervice,
            cache: chatContactsResponseCache
        )
    }
    
    
    func makeChatContactsQueriesRepository() -> IChatContactsQueriesRepository {
        DefaultChatContactsQueriesRepository(
            chatContactsQueriesPersistentStorage: chatContactsQueriesStorage
        )
    }
    
    private func makeKeychainRepository() -> IKeychainRepository {
        return DefaultKeychainRepository()
    }

    
    // MARK: - Chat Contacts List
    func makeChatContactsListViewController(actions: ChatContactsListViewModelActions) -> UIViewController {
        if #available(iOS 13.0, *) { // SwiftUI
            let view = ChatContactsView(
                viewModelWrapper: makeChatContactsViewModelWrapper(actions: actions)
            )
            
            return UIHostingController(rootView: view)
        } else { // UIKit
            return ChatContactsListVC.create(
                with: makeChatContactsListViewModel(actions: actions)
            )
        }
    }
    
    func makeChatContactsListViewModel(actions: ChatContactsListViewModelActions) -> ChatContactsViewModel {
        DefaultChatContactsViewModel(
            fetchChatContactsUseCase: makeFetchContactsUseCase(),
            getUserTokenDataUseCase: makeGetCurrentUserTokenUseCase(),
            actions: actions
        )
    }
    
    func makeChatContactsDetailsViewController(chatContact: ChatContact) -> UIViewController {
        print("Implement later: ", chatContact)
        
        return UIViewController()
    }
    
    func makeChattingViewController(chatContact: ChatContact) -> UIViewController {
        print("Implement later: ", chatContact)
        
        return UIViewController()
    }
    
    func makeChatContactsQueriesSuggestionsListViewController(didSelect: @escaping ChatContactsQueryListViewModelDidSelectAction) -> UIViewController {
        print("Implement later: ", didSelect)
        
        return UIViewController()
    }

    
    // MARK: - ViewModelWrapper (For SwiftUI)
    @available(iOS 13.0, *)
    func makeChatContactsViewModelWrapper(
        actions: ChatContactsListViewModelActions
    ) -> ChatContactsViewModelWrapper {
        ChatContactsViewModelWrapper(
            viewModel: makeChatContactsListViewModel(actions: actions)
        )
    }
    
    // MARK: - Flow Coordinators
    func makeChatContactsListFlowCoordinator(
        navigationController: UINavigationController
    ) -> ChatContactsListFlowCoordinator {
        ChatContactsListFlowCoordinator(
            navigationController: navigationController,
            dependencies: self
        )
    }
}
