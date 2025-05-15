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
        actions: ChatContactsListViewModelActions
    ) -> UIViewController
    func makeChatContactsDetailsViewController(chatContact: ChatContact) -> UIViewController
    func makeChattingViewController(chatContact: ChatContact) -> UIViewController
    func makeChatContactsQueriesSuggestionsListViewController(
        didSelect: @escaping ChatContactsQueryListViewModelDidSelectAction
    ) -> UIViewController
}


final class ChatContactsListFlowCoordinator: Coordinator {
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
        let actions = ChatContactsListViewModelActions(
            showChattingPage: showChattingView,
            showChatContactDetails: showChatContactDetails,
            showChatContactsQueriesSuggestions: showChatContactQueriesSuggestions,
            closeChatContactsQueriesSuggestions: closeChatContactQueriesSuggestions
        )
        let vc = dependencies.makeChatContactsListViewController(actions: actions)
        navigationController?.pushViewController(vc, animated: false)
        chatContactsListVC = vc
    }
    
    // DebugPoint 3 - Missplaced Flow, Might need to move it in chattingflow
    private func showChattingView(chatContact: ChatContact) {
        let vc = dependencies.makeChattingViewController(chatContact: chatContact)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func showChatContactDetails(chatContact: ChatContact) {
        let vc = dependencies.makeChatContactsDetailsViewController(chatContact: chatContact)
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
