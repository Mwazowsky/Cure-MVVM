//
//  AccountFlowCoordinatorDependencies.swift
//  Cure
//
//  Created by MacBook Air MII  on 28/3/25.
//

import UIKit

protocol AccountFlowCoordinatorDependencies {
    func makeAccountViewController(actions: AccountViewModelActions) -> AccountVC
}

protocol AccountFlowCoordinatorDelegate: AnyObject {
    func accountFlowDidFinish()
}

final class AccountFlowCoordinator: Coordinator {
    var type: CoordinatorType { .app }
    
    var childCoordinators: [Coordinator] = [Coordinator]()
    
    weak var navigationController: UINavigationController?
    private let dependencies: AccountFlowCoordinatorDependencies
    private weak var delegate: AccountFlowCoordinatorDelegate?
    
    weak var parentCoordinator: HomeFlowCoordinator?
    
    private weak var accountVC: AccountVC?
    
    init(
        navigationController: UINavigationController,
        dependencies: AccountFlowCoordinatorDependencies,
        delegate: AccountFlowCoordinatorDelegate? = nil
    ) {
        self.navigationController = navigationController
        self.dependencies = dependencies
        self.delegate = delegate
    }
    
    func start() {
        showAccount()
    }
    
    func finish() {
        parentCoordinator?.childDidFinish(self)
        parentCoordinator?.homeFlowDidFinish()
    }
    
    private func showAccount() {
        let actions = AccountViewModelActions(
            showForgotPassword: showForgotPassword,
            logoutDidSucceed: logoutDidSucceed
        )
        
        let vc = dependencies.makeAccountViewController(actions: actions)
        
        navigationController?.pushViewController(vc, animated: false)
        accountVC = vc
    }
    
    private func showForgotPassword() {
        //        let vc = dependencies.makeMoviesDetailsViewController(movie: movie)
        //        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func logoutDidSucceed() -> Void {
        print("logoutDidSucceed, executing self.finish()")
        self.finish()
    }
}
