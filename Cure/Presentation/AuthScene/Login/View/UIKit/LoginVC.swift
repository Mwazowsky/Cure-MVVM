//
//  LoginVC.swift
//  ExampleMVVM
//
//  Created by MacBook Air MII  on 19/03/25.
//

import Foundation
import UIKit

final class LoginVC: UIViewController {
    private var viewModel: LoginViewModel!
    
    // UI Components
    private lazy var loginPage: LoginFormCUREUIKit = LoginFormCUREUIKit(viewModel: viewModel)
    
    // MARK: - Lifecycle
    static func create(with viewModel: LoginViewModel) -> LoginVC {
        let vc = LoginVC()
        vc.viewModel = viewModel
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - Setup
    private func setupViews() {
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
        } else {
            view.backgroundColor = .white
        }
        
        view.addSubview(loginPage)
        
        loginPage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            loginPage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginPage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loginPage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            loginPage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
        ])
    }
}
