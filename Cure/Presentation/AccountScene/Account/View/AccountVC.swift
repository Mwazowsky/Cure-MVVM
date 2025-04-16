//
//  ReadyViewController.swift
//  Cure
//
//  Created by MacBook Air MII  on 27/3/25.
//

import UIKit

class AccountVC: UIViewController {

    var didSendEventClosure: ((AccountVC.Event) -> Void)?
    
    private var viewModel: AccountViewModel!

    private let logoutButton: UIButton = {
        let button = UIButton()
        button.setTitle("Logout", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8.0
        
        return button
    }()
    
    static func create(with viewModel: AccountViewModel) -> AccountVC {
        let vc = AccountVC()
        vc.viewModel = viewModel
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        view.addSubview(logoutButton)

        logoutButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            logoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoutButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            logoutButton.widthAnchor.constraint(equalToConstant: 200),
            logoutButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        logoutButton.addTarget(self, action: #selector(didTapLogoutButton(_:)), for: .touchUpInside)
    }
    
    deinit {}

    @objc private func didTapLogoutButton(_ sender: Any) {
        didSendEventClosure?(.account)
        viewModel.didTapLogoutButton()
    }
}

extension AccountVC {
    enum Event {
        case account
    }
}
