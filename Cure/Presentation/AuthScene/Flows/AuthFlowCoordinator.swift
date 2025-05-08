//
//  AuthFlowCoordinator.swift
//  ExampleMVVM
//
//  Created by MacBook Air MII  on 19/03/25.
//

import UIKit

protocol AuthFlowCoordinatorDependencies {
    func makeLoginViewController(actions: LoginViewModelActions) -> UIViewController
}

protocol AuthFlowCoordinatorDelegate: AnyObject {
    func authFlowDidFinish(with user: UserDetailsDM)
}

final class AuthFlowCoordinator: Coordinator {
    var type: CoordinatorType { .login }
    
    var childCoordinators: [Coordinator] = [Coordinator]()
    
    weak var navigationController: UINavigationController?
    private let dependencies: AuthFlowCoordinatorDependencies
    private weak var delegate: AuthFlowCoordinatorDelegate?
    
    weak var parentCoordinator: AppFlowCoordinator?
    
    private weak var loginVC: UIViewController?
    
    init(
        navigationController: UINavigationController,
        dependencies: AuthFlowCoordinatorDependencies,
        delegate: AuthFlowCoordinatorDelegate? = nil
    ) {
        self.navigationController = navigationController
        self.dependencies = dependencies
        self.delegate = delegate
    }
    
    func start() {
        showLogin()
    }
    
    func finish() {
        parentCoordinator?.childDidFinish(self)
    }
    
    private func showLogin() {
        let actions = LoginViewModelActions(
            showRegister: showRegister,
            showForgotPassword: showForgotPassword,
            loginDidSucceed: loginDidSucceed
        )
        
        let vc = dependencies.makeLoginViewController(actions: actions)
        
        navigationController?.pushViewController(vc, animated: false)
        loginVC = vc
    }
    
    private func showRegister() {
        //        let vc = dependencies.makeMoviesDetailsViewController(movie: movie)
        //        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func showForgotPassword() {
        //        let vc = dependencies.makeMoviesDetailsViewController(movie: movie)
        //        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func loginDidSucceed(user: UserDetailsDM) {
        delegate?.authFlowDidFinish(with: user)
        self.finish()
    }
}
