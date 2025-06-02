//
//  ReadyViewController.swift
//  Cure
//
//  Created by MacBook Air MII  on 27/3/25.
//

import UIKit

class ChatContactsListVC: UIViewController, Alertable {
    var filteredContacts: [ChatContactsListItemViewModel] = []
    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var didSendEventClosure: ((ChatContactsListVC.Event) -> Void)?
    
    let searchController = UISearchController(searchResultsController: nil)
    
    private var viewModel: ChatContactsViewModel!
    
    static func create(
        with viewModel: ChatContactsViewModel
    ) -> ChatContactsListVC {
        let view = ChatContactsListVC()
        
        view.viewModel = viewModel
        
        return view
    }
    
    let parentView: UIView = UIView()
    
    private var loadingView: UIActivityIndicatorView = UIActivityIndicatorView()
    private var emptyDataLabel: UILabel = UILabel()
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
        } else {
//            let darkModeEnabled = KeychainWrapper.standard.string(forKey: "darkMode") == "true"
//            view.backgroundColor = darkModeEnabled ? UIColor.black : UIColor.white
        }
        
        title = "Chats"
        
        bind(to: viewModel)
        
        setupSearchController()
        
        self.chatContactsTableViewController = ChatContactsTableViewController()
        chatContactsTableViewController?.viewModel = viewModel
        
        viewModel.viewDidLoad()
        
        guard let chatContactsTVController = chatContactsTableViewController else { return }
        
        parentView.backgroundColor = DesignTokens.LegacyColors.primary
        parentView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(parentView)

        NSLayoutConstraint.activate([
            parentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            parentView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            parentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            parentView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        parentView.addSubview(chatContactsTVController.view)

        NSLayoutConstraint.activate([
            chatContactsTVController.view.topAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.topAnchor),
            chatContactsTVController.view.bottomAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.bottomAnchor),
            chatContactsTVController.view.leadingAnchor.constraint(equalTo: parentView.leadingAnchor),
            chatContactsTVController.view.trailingAnchor.constraint(equalTo: parentView.trailingAnchor)
        ])
        
        chatContactsTableViewController?.didMove(toParent: self)
        self.chatContactsTableViewController = chatContactsTVController
    }
    
    func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Contacts..."
        
        if let textField = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            textField.backgroundColor = DesignTokens.LegacyColors.textBackground
        }

        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    deinit {}
    
    private func bind(to viewModel: ChatContactsViewModel) {
        viewModel.items.observe(on: self) { [weak self] _ in self?.updateItems() }
        viewModel.loading.observe(on: self) { [weak self] in self?.updateLoading($0) }
        viewModel.error.observe(on: self) { [weak self] in self?.showError($0) }
    }

    @objc private func didTapBroadcastButton(_ sender: Any) {
        didSendEventClosure?(.chats)
    }
    
    private func updateViewsVisibility(model: ChatContactsViewModel) {
        loadingView.isHidden = true
        emptyDataLabel.isHidden = true
        suggestionsListContainer.isHidden = true
        
//        updateQueriesSuggestionsVisibility()
    }
    
//    private func updateQueriesSuggestionsVisibility() {
//        if searchController.searchBar.isFirstResponder {
//            viewModel.showQueriesSuggestions()
//        } else {
//            viewModel.closeQueriesSuggestions()
//        }
//    }
    
    private func updateItems() {
        chatContactsTableViewController?.reload()
    }
    
    private func updateLoading(_ loading: ChatContactsViewModelLoading?) {
        emptyDataLabel.isHidden = true
        suggestionsListContainer.isHidden = true
    }
    
    private func showError(_ error: String) {
        guard !error.isEmpty else { return }
        showAlert(title: viewModel.errorTitle, message: error)
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filteredContacts = viewModel.items.value.filter { (contact: ChatContactsListItemViewModel) -> Bool in
            return contact.contactName.lowercased().contains(searchText.lowercased())
      }
      
        chatContactsTableViewController?.tableView.reloadData()
    }
}


extension ChatContactsListVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
}


extension ChatContactsListVC: UISearchBarDelegate {
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
        chatContactsTableViewController?.tableView.setContentOffset(CGPoint.zero, animated: false)
        viewModel.didSearch(query: searchText)
    }
    
    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.didCancelSearch()
    }
}

extension ChatContactsListVC: UISearchControllerDelegate {
    public func willPresentSearchController(_ searchController: UISearchController) {
//        updateQueriesSuggestionsVisibility()
    }
    
    public func willDismissSearchController(_ searchController: UISearchController) {
//        updateQueriesSuggestionsVisibility()
    }
    
    public func didDismissSearchController(_ searchController: UISearchController) {
//        updateQueriesSuggestionsVisibility()
    }
}


// MARK: - Setup Search Controller

//extension ChatContactsListVC {
//    private func setupSearchController() {
//    }
//}


extension ChatContactsListVC {
    enum Event {
        case chats
    }
}
