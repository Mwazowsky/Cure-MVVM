//
//  ReadyViewController.swift
//  Cure
//
//  Created by MacBook Air MII  on 27/3/25.
//

import UIKit

class AccountVC: UIViewController {

    var didSendEventClosure: ((AccountVC.Event) -> Void)?
    
    private let nameLabel = UILabel()
    private let emailLabel = UILabel()
    private let phoneLabel = UILabel()
    
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

        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
        } else {
            // Fallback on earlier versions
        }

        setupUI()
        bind(to: viewModel)
        viewModel.viewDidLoad()
    }
    
    private func setupUI() {
        view.addSubview(nameLabel)
        view.addSubview(emailLabel)
        view.addSubview(phoneLabel)
        view.addSubview(logoutButton)

        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        phoneLabel.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),

            emailLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 12),
            
            phoneLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            phoneLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 12),

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
    
    private func bind(to viewModel: AccountViewModel) {
        viewModel.userDetailsData.observe(on: self) { [weak self] userData in
            if let userData = userData {
                self?.displayUserDetails(userData)
            }
        }
    }
    
    private func displayUserDetails(_ details: UserDetailsDM) {
        nameLabel.text = "Name: \(details.name)"
        emailLabel.text = "Email: \(details.email)"
        phoneLabel.text = "Phone: \(String(describing: details.phoneNumber))"
    }
}

extension AccountVC {
    enum Event {
        case account
    }
}
