//
//  ReadyViewController.swift
//  Cure
//
//  Created by MacBook Air MII  on 27/3/25.
//

import UIKit

class ChatListVC: UIViewController {

    var didSendEventClosure: ((ChatListVC.Event) -> Void)?

    private let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8.0
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        view.addSubview(loginButton)

        loginButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loginButton.widthAnchor.constraint(equalToConstant: 200),
            loginButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        loginButton.addTarget(self, action: #selector(didTapLoginButton(_:)), for: .touchUpInside)
    }
    
    deinit {
        print("LoginViewController deinit")
    }

    @objc private func didTapLoginButton(_ sender: Any) {
        didSendEventClosure?(.chats)
    }
}

extension ChatListVC {
    enum Event {
        case chats
    }
}
