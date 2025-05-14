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

    private let broadcastBtn: UIButton = {
        let button = UIButton()
        button.setTitle("", for: .normal)
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

        
        view.addSubview(broadcastBtn)

        broadcastBtn.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            broadcastBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            broadcastBtn.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            broadcastBtn.widthAnchor.constraint(equalToConstant: 200),
            broadcastBtn.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        broadcastBtn.addTarget(self, action: #selector(didTapBroadcastButton(_:)), for: .touchUpInside)
        
        viewModel.viewDidLoad()
    }
    
    deinit {}

    @objc private func didTapBroadcastButton(_ sender: Any) {
        didSendEventClosure?(.chats)
    }
}

extension ChatContactsListVC {
    enum Event {
        case chats
    }
}
