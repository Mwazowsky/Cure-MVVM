//
//  ChattingFlowCoordinator.swift
//  Cure
//
//  Created by MacBook Air MII  on 19/5/25.
//

import UIKit

typealias ChattingQueryListVIewModelDidSelectAction = (ChattingQuery) -> Void

protocol ChattingFlowCoordinatorDependencies {
    func makeChattingViewController(
        actions: ChattingViewModelActions
    ) -> UIViewController
    
    func makeChatContactsDetailsViewController(chatContact: ChatContact) -> UIViewController
    func makeMessageDetailsViewController(chatContact: ChatContact) -> UIViewController
    func makeMessageQueriesSuggestionsListViewController(
        didSelect: @escaping ChatContactsQueryListViewModelDidSelectAction
    ) -> UIViewController
}

protocol ChattingFlowCoordinatorDelegate: AnyObject {
    func chattingFlowDidFinish()
}


final class ChattingFlowCoordinator: Coordinator {
    private let appDIContainer: AppDIContainer
    
    var childCoordinators: [any Coordinator]
    
    var navigationController: UINavigationController?
    
    var type: CoordinatorType { .app }
    
    private let dependencies: ChattingFlowCoordinatorDependencies
    private weak var delegate: ChattingFlowCoordinatorDelegate?
    
    weak var parentCoordinator: ChatContactsListFlowCoordinator?
    //
    //
    
    
    private let windowManager: WindowManageable
    
    init(
        navigationController: UINavigationController? = nil,
        appDIContainer: AppDIContainer,
        dependencies: ChattingFlowCoordinatorDependencies,
        delegate: ChattingFlowCoordinatorDelegate? = nil
    ) {
        self.navigationController = navigationController
        self.appDIContainer = appDIContainer
        self.dependencies = dependencies
        self.delegate = delegate
        self.windowManager = appDIContainer.windowManager
    }
    
    deinit {
        
    }
    
    func start() {
        <#code#>
    }
    
    func finish() {
        parentCoordinator?.childDidFinish(self)
    }
    
//    private func showChatContactsFlow(navigationController: UINavigationController) {
//        let chatContactsSceneDIContainer = appDIContainer.makeChatContactsSceneDIContainer()
//        let chatContactsFlowDIContainer = chatContactsSceneDIContainer.makeChatContactsListFlowCoordinator(
//            navigationController: navigationController
//        )
//        
//        chatContactsFlowDIContainer.parentCoordinator = self
//        chatContactsFlowDIContainer.start()
//        
//        childCoordinators.append(chatContactsFlowDIContainer)
//    }
//    
//    private func showAccountFlow(navigationController: UINavigationController) {
//        let accountSceneDIContainer = appDIContainer.makeAccountSceneDIContainer()
//        let accountFlowCoordinator = accountSceneDIContainer.makeAccountFlowCoordinator(
//            navigationController: navigationController
//        )
//        
//        accountFlowCoordinator.parentCoordinator = self
//        accountFlowCoordinator.start()
//        
//        childCoordinators.append(accountFlowCoordinator)
//    }
}
