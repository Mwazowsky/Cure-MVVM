//
//  ReadyViewController.swift
//  Cure
//
//  Created by MacBook Air MII  on 27/3/25.
//

import UIKit

class ChatContactsListVC: UIViewController, Alertable {

    var didSendEventClosure: ((ChatContactsListVC.Event) -> Void)?
    
    private var viewModel: ChatContactsViewModel!
    
    static func create(
        with viewModel: ChatContactsViewModel
    ) -> ChatContactsListVC {
        let view = ChatContactsListVC()
        
        view.viewModel = viewModel
        
        return view
    }
    
    private(set) var suggestionsListContainer: UIView = {
        let view = UIView()
        
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
        } else {
            view.backgroundColor = .lightGray
        }
        
        return view
    }()

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

        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
        } else {
//            let darkModeEnabled = KeychainWrapper.standard.string(forKey: "darkMode") == "true"
//            view.backgroundColor = darkModeEnabled ? UIColor.black : UIColor.white
        }

        
        view.addSubview(loginButton)

        loginButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loginButton.widthAnchor.constraint(equalToConstant: 200),
            loginButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        loginButton.addTarget(self, action: #selector(didTapLoginButton(_:)), for: .touchUpInside)
        
        viewModel.viewDidLoad()
    }
    
    deinit {}

    @objc private func didTapLoginButton(_ sender: Any) {
        didSendEventClosure?(.chats)
    }
}

extension ChatContactsListVC {
    enum Event {
        case chats
    }
}
