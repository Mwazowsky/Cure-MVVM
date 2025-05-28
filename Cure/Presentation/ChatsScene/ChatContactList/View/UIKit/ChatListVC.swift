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
    
    private var searchController = UISearchController(searchResultsController: nil)
    
    static func create(
        with viewModel: ChatContactsViewModel
    ) -> ChatContactsListVC {
        let view = ChatContactsListVC()
        
        view.viewModel = viewModel
        
        return view
    }
    
    private var loadingView: UIActivityIndicatorView = UIActivityIndicatorView()
    private var emptyDataLabel: UILabel = UILabel()
    private var searchBarContainer: UIView = UIView()
    
    private var chatContactsContainer: UIView = UIView()
    
    private var chatContactsTableViewController: ChatContactsTableViewController?
    
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
        
        setupSearchController()
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        
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
    
    private func updateViewsVisibility(model: ChatContactsViewModel) {
        loadingView.isHidden = true
        emptyDataLabel.isHidden = true
        chatContactsContainer.isHidden = true
        suggestionsListContainer.isHidden = true
        
        updateQueriesSuggestionsVisibility()
    }
    
    private func updateQueriesSuggestionsVisibility() {
        if searchController.searchBar.isFirstResponder {
            viewModel.showQueriesSuggestions()
        } else {
            viewModel.closeQueriesSuggestions()
        }
    }
}


extension ChatContactsListVC: UISearchBarDelegate {
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
        searchController.isActive = false
        chatContactsTableViewController?.tableView.setContentOffset(CGPoint.zero, animated: false)
        viewModel.didSearch(query: searchText)
    }
    
    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.didCancelSearch()
    }
}

extension ChatContactsListVC: UISearchControllerDelegate {
    public func willPresentSearchController(_ searchController: UISearchController) {
        updateQueriesSuggestionsVisibility()
    }
    
    public func willDismissSearchController(_ searchController: UISearchController) {
        updateQueriesSuggestionsVisibility()
    }
    
    public func didDismissSearchController(_ searchController: UISearchController) {
        updateQueriesSuggestionsVisibility()
    }
}


// MARK: - Setup Search Controller

extension ChatContactsListVC {
    private func setupSearchController() {
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = NSLocalizedString("Search Movies", comment: "")
        if #available(iOS 9.1, *) {
            searchController.obscuresBackgroundDuringPresentation = false
        } else {
            searchController.dimsBackgroundDuringPresentation = true
        }
        searchController.searchBar.translatesAutoresizingMaskIntoConstraints = true
        searchController.searchBar.barStyle = .black
        searchController.searchBar.frame = searchBarContainer.bounds
        searchController.searchBar.autoresizingMask = [.flexibleWidth]
        searchBarContainer.addSubview(searchController.searchBar)
        definesPresentationContext = true
        searchController.accessibilityLabel = NSLocalizedString("Search Movies", comment: "")
    }
}


extension ChatContactsListVC {
    enum Event {
        case chats
    }
}
