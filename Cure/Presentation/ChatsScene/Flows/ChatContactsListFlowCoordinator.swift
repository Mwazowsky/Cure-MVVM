//
//  ChatContactsListFlowCoordinator.swift
//  Cure
//
//  Created by MacBook Air MII  on 2/5/25.
//

import UIKit

typealias ChatContactsQueryListViewModelDidSelectAction = (ChatContactQuery) -> Void

protocol ChatContactsListFlowCoordinatorDependencies {
    func makeChatContactsListViewController(
        actions: ChatContactsViewModelActions
    ) -> UIViewController
//    func makeChatContactsDetailsViewController(chatContact: ChatContact) -> UIViewController
    func makeChattingViewController(chatContact: ChatContact) -> UIViewController
    func makeChatContactsQueriesSuggestionsListViewController(
        didSelect: @escaping ChatContactsQueryListViewModelDidSelectAction
    ) -> UIViewController
}

final class ChatContactsListFlowCoordinator: Coordinator {
    private let appDIContainer: AppDIContainer
    
    var type: CoordinatorType { .app }
    var childCoordinators: [Coordinator] = [Coordinator]()
    
    weak var parentCoordinator: HomeFlowCoordinator?
    
    weak var navigationController: UINavigationController?
    private let dependencies: ChatContactsListFlowCoordinatorDependencies
    
    private weak var chatContactsListVC: UIViewController?
    private weak var chatContactsQueriesSuggestionsVC: UIViewController?
    
    init(
        navigationController: UINavigationController? = nil,
        dependencies: ChatContactsListFlowCoordinatorDependencies
    ) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        let actions = ChatContactsViewModelActions(
            showChattingPage: showChattingView,
            showChatContactsQueriesSuggestions: showChatContactQueriesSuggestions,
            closeChatContactsQueriesSuggestions: closeChatContactQueriesSuggestions
        )
        let vc = dependencies.makeChatContactsListViewController(actions: actions)
        navigationController?.pushViewController(vc, animated: false)
        chatContactsListVC = vc
    }
    
    // MARK: - This is flow
    private func showChattingFlow(navigationController: UINavigationController) {
        let chattingSceneDIContainer = appDIContainer.makeChattingSceneDIContainer()
        let chattingFlowDIContainer = chattingSceneDIContainer.makeChattingFlowCoordinator(
            navigationController: navigationController
        )
        
        chattingFlowDIContainer.parentCoordinator = self
        chattingFlowDIContainer.start()
        
        childCoordinators.append(chattingFlowDIContainer)
    }
    
    // MARK: - This is view
    /// DebugPoint 3 - Missplaced Flow, Might need to move it in chattingflow
    private func showChattingView(chatContact: ChatContact) {
        let vc = dependencies.makeChattingViewController(chatContact: chatContact)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func showChatContactQueriesSuggestions(didSelect: @escaping (ChatContactQuery) -> Void) {
        guard let _ = chatContactsListVC, chatContactsQueriesSuggestionsVC == nil else { return }
        
//        let container = chatContactsListViewController.suggestionsListContainer
        
        let vc = dependencies.makeChatContactsQueriesSuggestionsListViewController(didSelect: didSelect)
        
//        chatContactsListViewController.add(child: vc, container: container)
        chatContactsQueriesSuggestionsVC = vc
//        container.isHidden = false
    }
    
    private func closeChatContactQueriesSuggestions() {
        chatContactsQueriesSuggestionsVC?.remove()
        chatContactsQueriesSuggestionsVC = nil
//        chatContactsListVC?.suggestionsListContainer.isHidden = true
    }
}

extension ChatContactsListFlowCoordinator {
    func childDidFinish(_ child: Coordinator?) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
}
