//
//  ChattingDIContainer.swift
//  Cure
//
//  Created by MacBook Air MII  on 19/5/25.
//

import UIKit

final class ChattingDIContainer: ChattingFlowCoordinatorDependencies {
    struct Dependencies {
        let newApiDataTransferService: DataTransferService
        let imageDataTransferService: DataTransferService
    }
    
    private let windowManager: WindowManageable
    
    private let dependencies: Dependencies
    
    // MARK: - Persistent Storage
    /// Chatting
    lazy var chattingQueriesStorage: ChattingQueriesStorage  = CoreDataChattingsQueriesStorage(maxStorageLimit: 10)
    lazy var chattingResponseCache : ChattingResponseStorage = CoreDataChatContactsResponseStorage()

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    // MARK: - Use Cases
    /// Fetch Messages Use case
    func makeFetchMessagesUseCase() -> FetchMessagesUseCase {
        DefaultFetchMessagesUseCase(
            fetchMessageRepository: makeChattingRepository(),
            messagesQueryRepository: makeChattingQueriesRepository()
        )
    }
    
    func makeGetCurrentTokenUseCase() -> GetUserTokenUseCase {
        return DefaultGetCurrentUserTokenUseCase(keychainRepository: makeKeychainRepository())
    }
    
    // MARK: - Repositories
    func makeChattingRepository() -> IChattingRepository {
        DefaultChattingRepository(
            newDataTransferService: dependencies.newApiDataTransferService,
            cache: chattingResponseCache
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
    
    // MARK: - Flow Coordinator
    func makeChattingFlowCoordinator(
        navigationController: UINavigationController,
        delegate: ChattingFlowCoordinatorDelegate? = nil
    ) -> ChattingFlowCoordinator {
        return ChattingFlowCoordinator(
            navigationController: navigationController,
            appDIContainer: AppDIContainer(windowManager: windowManager),
            dependencies: self,
            delegate: delegate
        )
    }
    
    
    // MARK: - View Controller
    func makeChattingViewController(actions: ChattingViewModelActions) -> UIViewController {
        print("placeholder")
        
        return UIViewController()
    }
    
    func makeChatContactsDetailsViewController(chatContact: ChatContact) -> UIViewController {
        print("placeholder")
        
        return UIViewController()
    }
    
    func makeMessageDetailsViewController(chatContact: ChatContact) -> UIViewController {
        print("placeholder")
        
        return UIViewController()
    }
    
    func makeMessageQueriesSuggestionsListViewController(didSelect: @escaping ChatContactsQueryListViewModelDidSelectAction) -> UIViewController {
        print("placeholder")
        
        return UIViewController()
    }
}
