//
//  AuthFlowCoordinator.swift
//  ExampleMVVM
//
//  Created by MacBook Air MII  on 19/03/25.
//

import UIKit

protocol AuthFlowCoordinatorDependencies {
    func makeLoginViewController(actions: LoginViewModelActions) -> LoginViewController
}

protocol AuthFlowCoordinatorDelegate: AnyObject {
    func authFlowDidFinish(with user: LoginResponse)
}

final class AuthFlowCoordinator {
    private weak var navigationController: UINavigationController?
    private let dependencies: AuthFlowCoordinatorDependencies
    private weak var delegate: AuthFlowCoordinatorDelegate?
    
    private weak var loginVC: LoginViewController?
    
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
        // Clean up if needed
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
    
    private func loginDidSucceed(user: LoginResponse) {
        delegate?.authFlowDidFinish(with: user)
        finish()
    }
}
