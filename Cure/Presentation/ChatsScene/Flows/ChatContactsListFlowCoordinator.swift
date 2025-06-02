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

protocol ChatContactsFlowCoordinatorDelegate: AnyObject {
    func chatContactFlowDidFinish()
}

protocol ChatContactsListCoordinatorProtocol: Coordinator {
    func didSelectItem(_ item: ChattingListItemViewModel)
}
 
final class ChatContactsListFlowCoordinator: Coordinator {
    // MARK: - Dependencies
    weak var navigationController   : UINavigationController?
    private let appDIContainer      : AppDIContainer
    private let dependencies        : ChatContactsListFlowCoordinatorDependencies
    private weak var delegate       : HomeFlowCoordinatorDelegate?
    private let windowManager       : WindowManageable
    
    // MARK: - Coordinators
    weak var parentCoordinator      : HomeFlowCoordinator?
    var childCoordinators           : [Coordinator] = [Coordinator]()
    var type                        : CoordinatorType { .app }

    // MARK: - Controllers
    private weak var chatContactsListVC                 : UIViewController?
    private weak var chatContactsQueriesSuggestionsVC   : UIViewController?
    
    // MARK: - Base
    init(
        navigationController : UINavigationController? = nil,
        appDIContainer       : AppDIContainer,
        dependencies         : ChatContactsListFlowCoordinatorDependencies
    ) {
        self.navigationController = navigationController
        self.appDIContainer = appDIContainer
        self.dependencies = dependencies
        self.windowManager = appDIContainer.windowManager
    }
    
    func start() {
        let actions = ChatContactsViewModelActions(
            showChattingPage: showChattingPage,
            showChatContactsQueriesSuggestions: showChatContactQueriesSuggestions,
            closeChatContactsQueriesSuggestions: closeChatContactQueriesSuggestions
        )
        let vc = dependencies.makeChatContactsListViewController(actions: actions)
        navigationController?.pushViewController(vc, animated: false)
        chatContactsListVC = vc
        
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func finish() {
        parentCoordinator?.childDidFinish(self)
    }
    
    // MARK: - Flow
//    private func showChattingFlow(navigationController: UINavigationController) {
//        let chattingSceneDIContainer = appDIContainer.makeChattingSceneDIContainer()
//        let chattingFlowDIContainer = chattingSceneDIContainer.makeChattingFlowCoordinator(
//            navigationController: navigationController
//        )
//        
//        chattingFlowDIContainer.parentCoordinator = self
//        chattingFlowDIContainer.start()
//        
//        childCoordinators.append(chattingFlowDIContainer)
//    }

    // MARK: - View
    private func showChattingPage(chatContact: ChatContact) {
        let vc = dependencies.makeChattingViewController(chatContact: chatContact)
        navigationController?.pushViewController(vc, animated: true)
        navigationController?.isNavigationBarHidden = false
        vc.navigationController?.navigationBar.prefersLargeTitles = true
        vc.navigationController?.addLogoImage(imagePath: "profile-placeholder", navItem: vc.navigationItem)
        navigationController?.navigationBar.prefersLargeTitles = true
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

extension ChatContactsListFlowCoordinator: ChatContactsFlowCoordinatorDelegate {
    func chatContactFlowDidFinish() {
        parentCoordinator?.start()
    }
    
    func childDidFinish(_ child: Coordinator?) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
}
