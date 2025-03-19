//
//  AuthFlowCoordinator.swift
//  ExampleMVVM
//
//  Created by MacBook Air MII  on 19/03/25.
//

import UIKit

protocol Coordinator: AnyObject {
    func start()
    func finish()
}

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
        print("Login Success")

        /// [FIX] Replace this with a proper flow coordinator function, instead of restarting it with movieFlow.start()
        /// this will treat the hoe view as a navigation stack view instead of seperate main view
//        let moviesSceneDIContainer = appDIContainer.makeMoviesSceneDIContainer()
//        let movieFlow = moviesSceneDIContainer.makeMoviesSearchFlowCoordinator(navigationController: navigationController ?? UINavigationController())
//        
//        movieFlow.start()
        
        delegate?.authFlowDidFinish(with: user)
    }
}
