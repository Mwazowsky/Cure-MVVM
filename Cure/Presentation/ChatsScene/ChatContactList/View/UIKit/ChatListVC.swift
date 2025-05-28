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
        
        viewModel.viewDidLoad()
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
    
    private func updateItems() {
        chatContactsTableViewController?.reload()
    }
    
    private func updateLoading(_ loading: ChatContactsViewModelLoading?) {
        emptyDataLabel.isHidden = true
        chatContactsContainer.isHidden = true
        suggestionsListContainer.isHidden = true
        LoadingView.hide()
        
        switch loading {
        case .fullScreen: LoadingView.show()
        case .nextPage: chatContactsContainer.isHidden = false
        case .none:
            chatContactsContainer.isHidden = viewModel.isEmpty
            emptyDataLabel.isHidden = !viewModel.isEmpty
        }
    }
    
    private func showError(_ error: String) {
        guard !error.isEmpty else { return }
        showAlert(title: viewModel.errorTitle, message: error)
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
